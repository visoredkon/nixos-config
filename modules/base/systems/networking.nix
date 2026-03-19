{
  lib,
  pkgs,
  username,
  ...
}:

{
  networking = {
    networkmanager = {
      enable = true;

      plugins = with pkgs; [
        networkmanager-l2tp
      ];

      connectionConfig = {
        "ipv4.ignore-auto-dns" = true;

        "ipv6.ignore-auto-dns" = true;
        "ipv6.addr-gen-mode" = "stable-privacy";
        "ipv6.ip6-privacy" = 2;

        "wifi.powersave" = 2;
      };

      dns = "systemd-resolved";

      wifi = {
        backend = "iwd";
        powersave = false;
      };
    };

    nftables = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [ ];
      allowedTCPPorts = [ ];
    };

    nameservers = [
      "1.1.1.2#cloudflare-dns.com"
      "1.0.0.2#cloudflare-dns.com"
      "2606:4700:4700::1112#cloudflare-dns.com"
      "2606:4700:4700::1002#cloudflare-dns.com"
    ];

    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          AddressRandomization = "network";
          AddressRandomizationRange = "full";
        };
        Network = {
          EnableIPv6 = true;
        };
      };
    };
  };

  boot = {
    kernel = {
      sysctl = {
        "kernel.dmesg_restrict" = 1;
        "kernel.kptr_restrict" = 2;

        "net.core.default_qdisc" = "fq";
        "net.core.netdev_max_backlog" = 16384;
        "net.core.rmem_default" = 1048576;
        "net.core.rmem_max" = 67108864;
        "net.core.somaxconn" = 4096;
        "net.core.wmem_default" = 1048576;
        "net.core.wmem_max" = 67108864;

        "net.ipv4.conf.all.log_martians" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.default.log_martians" = 1;
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.default.send_redirects" = 0;

        "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_ecn" = 1;
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_fin_timeout" = 15;
        "net.ipv4.tcp_keepalive_intvl" = 10;
        "net.ipv4.tcp_keepalive_probes" = 6;
        "net.ipv4.tcp_keepalive_time" = 120;
        "net.ipv4.tcp_max_syn_backlog" = 8192;
        "net.ipv4.tcp_mtu_probing" = 1;
        "net.ipv4.tcp_rmem" = "4096 87380 67108864";
        "net.ipv4.tcp_slow_start_after_idle" = 0;
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.tcp_tw_reuse" = 1;
        "net.ipv4.tcp_wmem" = "4096 65536 67108864";

        "net.ipv4.udp_rmem_min" = 8192;
        "net.ipv4.udp_wmem_min" = 8192;

        "net.ipv6.conf.all.accept_ra" = 2;
        "net.ipv6.conf.all.accept_ra_defrtr" = 1;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.all.accept_source_route" = 0;
        "net.ipv6.conf.all.use_tempaddr" = 2;
        "net.ipv6.conf.default.accept_ra" = 2;
        "net.ipv6.conf.default.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_source_route" = 0;
        "net.ipv6.conf.default.use_tempaddr" = lib.mkForce 2;

        "net.ipv6.flowlabel_consistency" = 1;

        "net.ipv6.neigh.default.gc_thresh1" = 128;
        "net.ipv6.neigh.default.gc_thresh2" = 512;
        "net.ipv6.neigh.default.gc_thresh3" = 1024;
      };
    };

    kernelModules = [
      "tcp_bbr"
    ];
  };

  # https://github.com/NixOS/nixpkgs/issues/375352
  # debug command: `journalctl -fu NetworkManager -fu nm-l2tp-service`
  environment.etc."strongswan.conf".text = "";

  services = {
    resolved = {
      enable = true;

      settings = {
        Resolve = {
          FallbackDNS = [
            "1.1.1.1#one.one.one.one"
            "1.0.0.1#one.one.one.one"
            "2606:4700:4700::1111#one.one.one.one"
            "2606:4700:4700::1001#one.one.one.one"
          ];

          DNSOverTLS = "opportunistic";
          DNSSEC = "allow-downgrade";

          LLMNR = false;
          MulticastDNS = false;
        };
      };
    };
  };

  users.users.${username} = {
    extraGroups = [
      "networkmanager"
    ];
    packages = with pkgs; [
      dig
      iw
      linux-wifi-hotspot
      haveged
    ];
  };
}
