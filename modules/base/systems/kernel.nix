{ inputs, pkgs, ... }:

{
  imports = [
    inputs.chaotic.nixosModules.default
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-lto;
    # kernelPackages = pkgs.linuxPackages_cachyos;
    # kernelPackages = pkgs.linuxPackages_latest;
  };

  services.scx.enable = true;
}
