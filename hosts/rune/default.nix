{ hostname, ... }:

{
  imports = [
    ../../modules/base
  ];

  networking = {
    hostName = "${hostname}";
  };
}
