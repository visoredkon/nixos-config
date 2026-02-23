{ ... }:

{
  powerManagement = {
    enable = false;

    cpuFreqGovernor = "ondemand";
    powertop = {
      enable = false;
    };
  };

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "systemctl suspend";
      HandleLidSwitchDocked = "systemctl suspend";
    };

    tlp = {
      enable = true;

      settings = {
        # Controls ACPI Platform Profile (Cooling & TDP Logic).
        # 'low-power' is the primary power-saving mechanism for 12th Gen.
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        # Intel HWP Energy Performance Preference (EPP).
        # 'power' biases the scheduler towards E-cores on Alder Lake.
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # CPU Boost (Turbo) & HWP Dynamic Boost.
        # Disabling on BAT prevents high-voltage spikes, improving efficiency.
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;

        # AC: Uncapped. Let hardware boost to max limits.
        INTEL_GPU_MIN_FREQ_ON_AC = 0;
        INTEL_GPU_MAX_FREQ_ON_AC = 0;
        INTEL_GPU_BOOST_FREQ_ON_AC = 0;

        # BAT: Also set to Auto (0).
        # Why? Because 'PLATFORM_PROFILE_ON_BAT = low-power' already
        # constrains the GPU power budget drastically via TDP limits.
        # Hardcoding values here often causes UI lag without significant battery gains.
        INTEL_GPU_MIN_FREQ_ON_BAT = 0;
        INTEL_GPU_MAX_FREQ_ON_BAT = 0;
        INTEL_GPU_BOOST_FREQ_ON_BAT = 0;

        # PCIe Device Power Management.
        # 'on'   = Kernel PM Disabled (Devices always active, low latency).
        # 'auto' = Kernel PM Enabled (Devices suspend when idle).
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";

        # Driver 'ideapad_laptop' uses binary state, not percentage.
        # 1 = Conservation Mode (caps charge at ~79% for battery health).
        # 0 = Standard Mode (charges to 100%).
        START_CHARGE_THRESH_BAT0 = 0;
        STOP_CHARGE_THRESH_BAT0 = 1;

        # 0 = Disable power save (prevents audio latency/pops on AC).
        # 1 = Enable (1s timeout) for HDA controller power-down.
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;

        DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi";
        DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi";
      };
    };
  };
}
