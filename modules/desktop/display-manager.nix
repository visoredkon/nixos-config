{ pkgs, username, ... }:

{
  services = {
    seatd = {
      enable = true;
      user = "${username}";
    };

    displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };

        package = pkgs.kdePackages.sddm;
      };
    };
  };
}
