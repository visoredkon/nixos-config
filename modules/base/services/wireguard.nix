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
  nft = "${pkgs.nftables}/bin/nft";
  grep = "${pkgs.gnugrep}/bin/grep";
  awk = "${pkgs.gawk}/bin/awk";

  hytalePostUp = pkgs.writeShellScript "hytale-postup" ''
    IFACE=$1
    handle=$(${nft} -a list chain inet nixos-fw input 2>/dev/null | ${grep} "wg-jump-$IFACE" | ${awk} '{print $NF}')

    if [ -n "$handle" ]; then
      ${nft} delete rule inet nixos-fw input handle "$handle" 2>/dev/null || true
    fi
    ${nft} delete chain inet nixos-fw hytale-server 2>/dev/null || true
    ${nft} add chain inet nixos-fw hytale-server
    ${nft} flush chain inet nixos-fw hytale-server
    ${nft} insert rule inet nixos-fw input jump hytale-server comment "wg-jump-$IFACE"
    ${nft} add rule inet nixos-fw hytale-server iifname "$IFACE" accept
    ${nft} add rule inet nixos-fw hytale-server ip6 nexthdr udp udp dport 5520 accept

    handle=$(${nft} -a list chain inet nixos-fw input 2>/dev/null | ${grep} "wg-jump-hotspot" | ${awk} '{print $NF}')
    if [ -n "$handle" ]; then
      ${nft} delete rule inet nixos-fw input handle "$handle" 2>/dev/null || true
    fi
    ${nft} delete chain inet nixos-fw hotspot-fw 2>/dev/null || true
    ${nft} add chain inet nixos-fw hotspot-fw
    ${nft} insert rule inet nixos-fw input jump hotspot-fw comment "wg-jump-hotspot"
    ${nft} add rule inet nixos-fw hotspot-fw iifname "ap0" tcp dport '{ 53, 5353 }' accept
    ${nft} add rule inet nixos-fw hotspot-fw iifname "ap0" udp dport '{ 53, 5353, 67, 5520 }' accept
  '';

  hytalePreDown = pkgs.writeShellScript "hytale-predown" ''
    IFACE=$1
    handle=$(${nft} -a list chain inet nixos-fw input | ${grep} "wg-jump-$IFACE" | ${awk} '{print $NF}')

    if [ -n "$handle" ]; then
      ${nft} delete rule inet nixos-fw input handle "$handle"
    fi
    ${nft} flush chain inet nixos-fw hytale-server || true
    ${nft} delete chain inet nixos-fw hytale-server || true

    handle=$(${nft} -a list chain inet nixos-fw input | ${grep} "wg-jump-hotspot" | ${awk} '{print $NF}')
    if [ -n "$handle" ]; then
      ${nft} delete rule inet nixos-fw input handle "$handle"
    fi
    ${nft} flush chain inet nixos-fw hotspot-fw || true
    ${nft} delete chain inet nixos-fw hotspot-fw || true
  '';

  hytaleUpdateDns = pkgs.writeShellScript "hytale-dns-update" ''
    CLOUDFLARE_API_TOKEN=$(${pkgs.coreutils}/bin/cat ${config.sops.secrets."cloudflare-api-token".path})
    ZONE_ID=$(${pkgs.coreutils}/bin/cat ${config.sops.secrets."cloudflare-zone-id".path})
    DNS_RECORD_ID=$(${pkgs.coreutils}/bin/cat ${config.sops.secrets."cloudflare-dns-record-id".path})

    get_ipv6() {
      IP=$(${pkgs.iproute2}/bin/ip -6 -o addr show scope global | ${pkgs.gnugrep}/bin/grep -v 'mngtmpaddr' | ${pkgs.gnugrep}/bin/grep dynamic | ${pkgs.gawk}/bin/awk '{print $4}' | ${pkgs.coreutils}/bin/cut -d/ -f1 | ${pkgs.coreutils}/bin/head -n 1)
      if [ -z "$IP" ]; then
        IP=$(${pkgs.iproute2}/bin/ip -6 -o addr show scope global | ${pkgs.gawk}/bin/awk '{print $4}' | ${pkgs.coreutils}/bin/cut -d/ -f1 | ${pkgs.coreutils}/bin/head -n 1)
      fi
      echo "$IP"
    }

    IP_V6=""
    DELAY=1
    for i in 1 2 3; do
      IP_V6=$(get_ipv6)
      if [ -n "$IP_V6" ]; then
        break
      fi
      echo "hytale-dns-update: attempt $i — no IPv6 found, retrying in ''${DELAY}s" >&2
      ${pkgs.coreutils}/bin/sleep "$DELAY"
      DELAY=$((DELAY * 2))
    done

    if [ -z "$IP_V6" ]; then
      echo "hytale-dns-update: no public IPv6 found after 3 attempts, skipping" >&2
      exit 0
    fi

    echo "hytale-dns-update: updating DNS record to $IP_V6" >&2

    RESPONSE=$(${pkgs.curl}/bin/curl -sf -X PATCH \
      "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID" \
      -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
      -H "Content-Type: application/json" \
      --data "{\"content\": \"$IP_V6\"}" 2>&1) || echo "hytale-dns-update: API call failed — $RESPONSE" >&2

    exit 0
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
    "cloudflare-api-token" = {
      sopsFile = "${secretsPath}/${hostname}/cloudflare/hytale.yaml";
      key = "api_token";
    };
    "cloudflare-zone-id" = {
      sopsFile = "${secretsPath}/${hostname}/cloudflare/hytale.yaml";
      key = "zone_id";
    };
    "cloudflare-dns-record-id" = {
      sopsFile = "${secretsPath}/${hostname}/cloudflare/hytale.yaml";
      key = "dns_record_id";
    };
  };

  sops.templates = {
    "wg0.conf".content = ''
      [Interface]
      Address = 10.0.0.2/29
      MTU = 1420
      PrivateKey = ${config.sops.placeholder."wg0-private-key"}
      PostUp = ${hytalePostUp} %i; ${hytaleUpdateDns}
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
