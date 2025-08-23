{ hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/base

    ../../modules/desktop
  ];

  networking = {
    hostName = "${hostname}";
  };
}
