{
  config,
  pkgs,
  username,
  ...
}:

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

        pinentryPackage =
          if config.services.displayManager.sddm.enable then pkgs.pinentry-qt else pkgs.pinentry-curses;

        settings = {
          "default-cache-ttl" = 86400;
          "max-cache-ttl" = 86400;
        };
      };
    };

    seahorse.enable = true;
  };

  services = {
    gnome = {
      gnome-keyring = {
        enable = true;
      };

      gcr-ssh-agent = {
        enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [ libsecret ];

  users.users.${username} = {
    extraGroups = [
      "wheel"
    ];
  };
}
