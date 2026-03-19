{
  pkgs,
  ...
}:

{
  boot = {
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;

    kernel = {
      sysctl = {
        # "kernel.sched_migration_cost_ns" = 5000000;
        # "kernel.sched_min_granularity_ns" = 10000000;
        "kernel.timer_migration" = 0;

        "vm.dirty_background_ratio" = 5;
        "vm.dirty_ratio" = 10;
        "vm.lru_gen_enabled" = 1;
        "vm.page-cluster" = 0;
        "vm.swappiness" = 10;
        "vm.vfs_cache_pressure" = 50;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
      };
    };

    kernelParams = [
      "intel_pstate=active"
      "preempt=full"
      "usbcore.autosuspend=-1"
      "nowatchdog"
      "mitigations=auto"
    ];
  };

  services.scx = {
    enable = true;
    package = pkgs.scx.rustscheds;

    scheduler = "scx_bpfland";
    extraArgs = [
      "--primary-domain"
      "performance"
      "--preferred-idle-scan"
      "--local-pcpu"
      "--slice-us"
      "500"
      "--slice-us-lag"
      "20000"
    ];
  };
}
