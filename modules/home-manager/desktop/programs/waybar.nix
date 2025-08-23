{ ... }:

{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      target = "graphical-session.target";
    };

  };

  home = {
    file = {
      ".config/waybar" = {
        source = ../../dotconfig/waybar;
        recursive = true;
      };
      ".config/waybar/mocha.css" = {
        text = builtins.readFile (
          builtins.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/waybar/refs/heads/main/themes/mocha.css";
            sha256 = "sha256:05yx7v4j9k1s1xanlak7yngqfwvxvylwxc2fhjcfha68rjbhbqx6";
          }
        );
      };
    };
  };
}
