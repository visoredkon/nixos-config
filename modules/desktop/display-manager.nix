{
  pkgs,
  username,
  ...
}:

{
  services = {
    seatd = {
      enable = true;
      user = "${username}";
    };

    displayManager = {
      sddm = {
        enable = true;
        package = pkgs.qt6Packages.sddm;

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
