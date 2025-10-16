{ inputs, pkgs, ... }:

{
  imports = [
    inputs.chaotic.nixosModules.default
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    # kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_6_12;
  };

  services.scx.enable = true;
}
