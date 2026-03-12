{
  lib,
  pkgs,
  ...
}:

{
  boot = {
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
    # kernelPackages = pkgs.linuxPackages_latest;

    kernel = {
      sysctl = {
        "kernel.sched_migration_cost_ns" = 5000000;
        "kernel.sched_min_granularity_ns" = 10000000;
        "kernel.timer_migration" = 0;

        "net.core.default_qdisc" = "fq";
        "net.core.netdev_max_backlog" = 16384;
        "net.core.rmem_default" = 1048576;
        "net.core.rmem_max" = 67108864;
        "net.core.somaxconn" = 4096;
        "net.core.wmem_default" = 1048576;
        "net.core.wmem_max" = 67108864;

        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_ecn" = 1;
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_keepalive_intvl" = 10;
        "net.ipv4.tcp_keepalive_probes" = 6;
        "net.ipv4.tcp_keepalive_time" = 60;
        "net.ipv4.tcp_max_syn_backlog" = 8192;
        "net.ipv4.tcp_mtu_probing" = 1;
        "net.ipv4.tcp_rmem" = "4096 87380 67108864";
        "net.ipv4.tcp_slow_start_after_idle" = 0;
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.tcp_wmem" = "4096 65536 67108864";

        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.default.rp_filter" = 1;

        "net.ipv6.flowlabel_consistency" = 1;

        "net.ipv6.conf.all.accept_ra" = 2;
        "net.ipv6.conf.all.accept_ra_defrtr" = 1;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.all.accept_source_route" = 0;
        "net.ipv6.conf.all.use_tempaddr" = 2;

        "net.ipv6.conf.default.accept_ra" = 2;
        "net.ipv6.conf.default.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_source_route" = 0;
        "net.ipv6.conf.default.use_tempaddr" = lib.mkForce 2;

        "net.ipv6.neigh.default.gc_thresh1" = 128;
        "net.ipv6.neigh.default.gc_thresh2" = 512;
        "net.ipv6.neigh.default.gc_thresh3" = 1024;

        "vm.dirty_background_ratio" = 5;
        "vm.dirty_ratio" = 10;
        "vm.lru_gen_enabled" = 1;
        "vm.page-cluster" = 0;
        "vm.swappiness" = 5;
        "vm.vfs_cache_pressure" = 50;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
      };
    };

    kernelModules = [
      "tcp_bbr"
    ];
    kernelParams = [
      "intel_pstate=active"
      "preempt=full"
      "usbcore.autosuspend=-1"
    ];
  };

  services.scx = {
    enable = true;
    package = pkgs.scx.rustscheds;

    scheduler = "scx_bpfland";
    extraArgs = [
      "--primary-domain"
      "performance"
      "--no-wake-sync"
    ];
  };
}
