{ username, ... }:

{
  security = {
    rtkit = {
      enable = true;
    };

    pam = {
      services = {
        sddm = {
          enable = true;
          enableGnomeKeyring = true;
        };
      };
    };

    sudo = {
      enable = true;
      execWheelOnly = true;
    };
  };

  programs = {
    gnupg = {
      agent = {
        enable = true;
      };
    };

    seahorse.enable = true;
  };

  services = {
    gnome.gnome-keyring = {
      enable = true;
    };
  };

  users.users.${username} = {
    extraGroups = [
      "wheel"
    ];
  };
}
