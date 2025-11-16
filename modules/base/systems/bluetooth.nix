{ ... }:

{
  boot.extraModprobeConfig = ''
    # Enable software crypto (helps BT coexistence sometimes)
    options iwlwifi swcrypto=1

    # Disable power saving on Wi-Fi module to reduce radio state changes that might disrupt BT
    options iwlwifi power_save=0

    # Set power scheme for performance (iwlmvm)
    options iwlmvm power_scheme=1
  '';

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        ControllerMode = "dual";
        Experimental = true; # Show battery charge of Bluetooth devices (https://nixos.wiki/wiki/Bluetooth)
        FastConnectable = true;
      };
    };
  };
}
