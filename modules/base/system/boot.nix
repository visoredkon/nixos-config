{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;

        configurationLimit = 10;
      };
    };
  };
}
