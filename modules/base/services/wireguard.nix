/*
  - Problem: ISP cuma ngasi alamat IPv6 public (IPv4 pakai CGNAT) jadi peer IPv6-native
    bisa terhubung langsung via QUIC. Peer lain tanpa IPv6 harus tunnelling.
  - Architecture:
      - Native QUIC over IPv6 for client A -> allow only QUIC packets using nftables
        payload inspection (match QUIC 'fixed bit' 0x40) to avoid wide UDP exposure.
      - WireGuard interface (wg0) for client B -> trusted interface while wg0 up.
      - Dynamic lifecycle: firewall rules injected in PostUp and removed in PreDown.
*/
{
  config,
  hostname,
  pkgs,
  secretsPath,
  inputs,
  ...
}:
let
  hytalePostUp = pkgs.writeShellScript "hytale-postup" ''
    IFACE=$1
    PORT_RANGE=$(${pkgs.procps}/bin/sysctl -n net.ipv4.ip_local_port_range | ${pkgs.gawk}/bin/awk '{print $1"-"$2}')
    handle=$(${pkgs.nftables}/bin/nft -a list chain inet nixos-fw input 2>/dev/null | ${pkgs.gnugrep}/bin/grep "wg-jump-$IFACE" | ${pkgs.gawk}/bin/awk '{print $NF}')

    if [ -n "$handle" ]; then
      ${pkgs.nftables}/bin/nft delete rule inet nixos-fw input handle "$handle" 2>/dev/null || true
    fi
    ${pkgs.nftables}/bin/nft delete chain inet nixos-fw hytale-server 2>/dev/null || true
    ${pkgs.nftables}/bin/nft add chain inet nixos-fw hytale-server
    ${pkgs.nftables}/bin/nft flush chain inet nixos-fw hytale-server
    ${pkgs.nftables}/bin/nft add rule inet nixos-fw input jump hytale-server comment "wg-jump-$IFACE"
    ${pkgs.nftables}/bin/nft add rule inet nixos-fw hytale-server iifname "$IFACE" accept
    ${pkgs.nftables}/bin/nft add rule inet nixos-fw hytale-server ip6 nexthdr udp udp dport $PORT_RANGE '@th,64,8 & 0x40 == 0x40' accept
  '';

  hytalePreDown = pkgs.writeShellScript "hytale-predown" ''
    IFACE=$1
    handle=$(${pkgs.nftables}/bin/nft -a list chain inet nixos-fw input | ${pkgs.gnugrep}/bin/grep "wg-jump-$IFACE" | ${pkgs.gawk}/bin/awk '{print $NF}')

    if [ -n "$handle" ]; then
      ${pkgs.nftables}/bin/nft delete rule inet nixos-fw input handle "$handle"
    fi
    ${pkgs.nftables}/bin/nft flush chain inet nixos-fw hytale-server || true
    ${pkgs.nftables}/bin/nft delete chain inet nixos-fw hytale-server || true
  '';
in
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  sops.secrets = {
    "wg0-private-key" = {
      sopsFile = "${secretsPath}/${hostname}/wireguard/wg0.yaml";
      key = "private_key";
    };
    "wg0-endpoint" = {
      sopsFile = "${secretsPath}/${hostname}/wireguard/wg0.yaml";
      key = "endpoint";
    };
  };

  sops.templates = {
    "wg0.conf".content = ''
      [Interface]
      Address = 10.0.0.2/29
      MTU = 1420
      PrivateKey = ${config.sops.placeholder."wg0-private-key"}
      PostUp = ${hytalePostUp} %i
      PreDown = ${hytalePreDown} %i

      [Peer]
      AllowedIPs = 10.0.0.0/29
      Endpoint = ${config.sops.placeholder."wg0-endpoint"}
      PersistentKeepalive = 25
      PublicKey = ${builtins.elemAt (pkgs.lib.splitString "\n" (builtins.readFile "${inputs.secrets}/${hostname}/wireguard/public-keys/wg0")) 1}
    '';
  };

  networking = {
    wg-quick.interfaces = {
      wg0 = {
        autostart = false;
        configFile = config.sops.templates."wg0.conf".path;
      };
    };
  };
}
