{
  pkgs,
  ...
}:

{
  boot = {
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;

    kernel = {
      sysctl = {
        "kernel.unprivileged_userns_clone" = 1;
        "vm.dirty_background_ratio" = 5;
        "vm.dirty_ratio" = 10;
        "vm.page-cluster" = 0;
        "vm.swappiness" = 180;
        "vm.vfs_cache_pressure" = 50;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
      };
    };

    kernelParams = [
      "i915.enable_fbc=1"
      "i915.enable_guc=3"
      "i915.enable_psr=0"
      "intel_idle.max_cstate=4"
      "intel_pstate=active"
      # mitigations=on: security over performance (5-10% penalty on pre-2020 CPUs)
      "mitigations=on"
      "usbcore.autosuspend=-1"
      "nowatchdog"
      "panic=5"
      "split_lock_detect=off"
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

  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
  };
}
