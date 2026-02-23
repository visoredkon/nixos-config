{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

let
  mkFhsApp =
    {
      name,
      pkg,
      extraPkgs ? [ ],
      runScript ? name,
    }:
    pkgs.buildFHSEnv {
      inherit name runScript;
      targetPkgs = pkgs: [ pkg ] ++ (if builtins.isList extraPkgs then extraPkgs else extraPkgs pkgs);
    };

  mkWrappedApp =
    {
      name,
      pkg,
      extraPkgs ? [ ],
    }:
    with pkgs;
    symlinkJoin {
      inherit name;
      paths = [ pkg ];
      buildInputs = [ makeBinaryWrapper ];
      postBuild = ''
        for bin in $out/bin/*; do
          wrapProgram $bin \
            --prefix PATH : ${
              lib.makeBinPath (if builtins.isList extraPkgs then extraPkgs else extraPkgs pkgs)
            }
        done
      '';
    };

  antigravity-wrapped = mkFhsApp {
    name = "antigravity";
    pkg = (
      pkgs-unstable.antigravity.override {
        commandLineArgs = [ "--password-store=gnome-libsecret" ];
      }
    );
    extraPkgs =
      pkgs: with pkgs; [
        google-chrome
        nodejs_latest
        uv
      ];
  };

  # phpstorm-wrapped = mkWrappedApp {
  #   name = "phpstorm";
  #   pkg = (
  #     pkgs-unstable.jetbrains.phpstorm.override {
  #       jdk = pkgs-unstable.jetbrains.jdk;
  #     }
  #   );
  #   extraPkgs = with pkgs; [
  #     nodejs_latest
  #   ];
  # };

  vscode-wrapped = mkWrappedApp {
    name = "code";
    pkg = (
      pkgs-unstable.vscode.override {
        commandLineArgs = [ "--password-store=gnome-libsecret" ];
      }
    );
    extraPkgs = with pkgs; [
      dotnetCorePackages.sdk_10_0-bin
      javaPackages.compiler.temurin-bin.jdk-25
      nodejs_latest
    ];
  };

  pkgGroups = {
    communications = with pkgs; [
      discord
    ];

    devs = with pkgs; [
      postman

      antigravity-wrapped
      vscode-wrapped
    ];

    entertainments = with pkgs; [
      spotify
    ];

    games = with pkgs; [
      hytale-launcher
    ];

    office = with pkgs; [
      zotero
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
    ];

    gui-utils = with pkgs; [
      libnotify
      pwvucontrol
    ];
  };
in
{
  home = {
    packages = lib.flatten (lib.attrValues pkgGroups);

    file = {
      ".ideavimrc".source = ../dotconfig/.ideavimrc;

      ".config/swappy" = {
        source = ../dotconfig/swappy;
        recursive = true;
      };
    };
  };
}
