{ pkgs, ... }:
let
  phpstorm-wrapped = pkgs.buildFHSEnv {
    name = "phpstorm";

    targetPkgs =
      pkgs: with pkgs; [
        (jetbrains.phpstorm.override {
          jdk = pkgs.jetbrains.jdk;
        })

        nodejs_latest
      ];

    runScript = "phpstorm";
  };
  vscode-wrapped = pkgs.buildFHSEnv {
    name = "code";

    targetPkgs =
      pkgs: with pkgs; [
        (vscode.override {
          commandLineArgs = [
            "--password-store=gnome-libsecret"
          ];
        })

        nodejs_latest
      ];

    runScript = "code";
  };
in
{
  home = {
    packages =
      let
        communications = with pkgs; [
          discord
        ];

        devs = [
          phpstorm-wrapped
          vscode-wrapped
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
