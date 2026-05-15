_:

{
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0
    options iwlwifi uapsd_disable=1
    options iwlmvm power_scheme=1
  '';

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        Experimental = true; # Show battery charge of Bluetooth devices (https://nixos.wiki/wiki/Bluetooth)
        ControllerMode = "dual";
        FastConnectable = true;
      };
    };
  };

  services = {
    blueman = {
      enable = true;
    };
  };

}
