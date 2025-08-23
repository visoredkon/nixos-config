{ ... }:

{
  services = {
    mako = {
      enable = true;
    };
    network-manager-applet = {
      enable = true;
    };
  };

  home = {
    file = {
      ".config/mako" = {
        source = ../dotconfig/mako;
        recursive = true;
      };
    };
  };
}
