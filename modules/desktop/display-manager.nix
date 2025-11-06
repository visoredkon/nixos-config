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
        package = pkgs.kdePackages.sddm;

        wayland = {
          enable = true;
        };
      };
    };
  };

  users.users.${username} = {
    extraGroups = [
      "seat"
    ];
  };
}
