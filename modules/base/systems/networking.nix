{
  lib,
  pkgs,
  username,
  ...
}:
let
  dnsServers = [
    "1.1.1.2"
    "1.0.0.2"
    # "1.1.1.1#one.one.one.one"
    # "1.0.0.1#one.one.one.one"
  ];
in
{
  networking = {
    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;
    useDHCP = lib.mkDefault true;

    networkmanager = {
      enable = true;

      plugins = with pkgs; [
        networkmanager-l2tp
      ];

      # Ada masalah pake "systemd-resolved"
      # WARP jadi sering error dan `bun install` di Docker jadi suka bermasalah
      # dns = "systemd-resolved";
      # ethernet = {
      #   macAddress = "stable";
      # };
      wifi = {
        macAddress = "random";
      };
    };

    firewall = {
      enable = true;

      allowedUDPPorts = [ ];
      allowedTCPPorts = [ ];
    };

    nameservers = dnsServers;
  };

  # services.resolved = {
  #   enable = true;
  #
  #   dnssec = "true";
  #   domains = [ "~." ];
  #   fallbackDns = dnsServers;
  #   dnsovertls = "true";
  # };

  # https://github.com/NixOS/nixpkgs/issues/375352
  # debug command: `journalctl -fu NetworkManager -fu nm-l2tp-service`
  environment.etc."strongswan.conf".text = "";

  users.users.${username} = {
    extraGroups = [
      "networkmanager"
    ];
  };
}
