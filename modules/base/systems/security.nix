{ username, ... }:

{
  security = {
    rtkit = {
      enable = true;
    };

    pam = {
      services = {
        sddm.enableGnomeKeyring = true;
      };
    };

    sudo = {
      enable = false;
      execWheelOnly = true;
    };

    sudo-rs = {
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
