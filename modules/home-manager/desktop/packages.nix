{ pkgs, ... }:

{
  home = {
    packages =
      let
        communications = with pkgs; [
          discord
        ];

        entertainments = with pkgs; [
          spotify
        ];

        devs = with pkgs; [
          jetbrains.jdk
          jetbrains.phpstorm
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
      communications ++ entertainments ++ devs ++ gui-utils ++ cli-utils ++ nonPkgs;

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
