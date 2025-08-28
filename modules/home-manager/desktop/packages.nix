{ pkgs, ... }:

{
  home = {
    packages =
      let
        communications = with pkgs; [
          discord
        ];

        devs = with pkgs; [
          jetbrains.jdk
          jetbrains.phpstorm
        ];

        entertainments = with pkgs; [
          spotify
        ];

        office = with pkgs; [
          obsidian
        ];

        gui-utils = with pkgs; [
          pwvucontrol
        ];

        cli-utils = with pkgs; [
          brightnessctl
          wl-clipboard

          grim
          jq
          slurp
          swappy

          libinput
          libinput-gestures

          libsForQt5.qt5.qtwayland
          kdePackages.qtwayland

          kdePackages.xwaylandvideobridge
        ];

        nonPkgs = [ ];
      in
      communications ++ devs ++ entertainments ++ office ++ gui-utils ++ cli-utils ++ nonPkgs;

    file = {
      ".ideavimrc" = {
        source = ../dotconfig/.ideavimrc;
      };
      ".config/swappy" = {
        source = ../dotconfig/swappy;
        recursive = true;
      };
    };
  };
}
