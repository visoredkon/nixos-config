{ inputs, pkgs, ... }:

{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = true;

    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 20;
    };
    fonts = {
      sizes = {
        desktop = 10; # 10
        applications = 10; # 12
        # popups = ; ngikutin desktop
        # terminal = ; ngikutin aapplications
      };

      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    icons = {
      enable = true;
      dark = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    targets = {
      zen-browser = {
        enable = false;

        profileNames = [ "default" ];
      };

      hyprland = {
        enable = false;
        hyprpaper.enable = true;
      };
      hyprlock = {
        enable = false;
      };

      bat = {
        enable = false;
      };
      btop = {
        enable = false;
      };
      fcitx5 = {
        enable = false;
      };
      fish = {
        enable = false;
      };
      kitty = {
        enable = false;
      };
      lazygit = {
        enable = false;
      };
      mako = {
        enable = false;
      };
      rofi = {
        enable = false;
      };
      starship = {
        enable = false;
      };
      waybar = {
        enable = false;
      };
      yazi = {
        enable = false;
      };
      zellij = {
        enable = false;
      };
    };

    # # System Wide (NixOSModules) Only
    # homeManagerIntegration = {
    #   autoImport = true;
    #   followSystem = true;
    # };
  };
}
