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
    let
      resolvedPkgs = if builtins.isList extraPkgs then extraPkgs else extraPkgs pkgs;
    in
    pkgs.buildFHSEnv {
      inherit name runScript;
      targetPkgs = _pkgs: [ pkg ] ++ resolvedPkgs;
    };

  mkWrappedApp =
    {
      name,
      pkg,
      extraPkgs ? [ ],
    }:
    let
      resolvedPkgs = if builtins.isList extraPkgs then extraPkgs else extraPkgs pkgs;
    in
    with pkgs;
    symlinkJoin {
      inherit name;
      paths = [ pkg ];
      buildInputs = [ makeBinaryWrapper ];
      postBuild = ''
        for bin in $out/bin/*; do
          wrapProgram $bin \
            --prefix PATH : ${lib.makeBinPath resolvedPkgs}
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
    extraPkgs = with pkgs; [
      google-chrome
      nodejs_latest
      uv
    ];
  };

  # idea-wrapped = mkWrappedApp {
  #   name = "idea";
  #   pkg = (
  #     pkgs-unstable.jetbrains.idea.override {
  #       jdk = pkgs-unstable.jetbrains.jdk;
  #     }
  #   );
  #   extraPkgs = with pkgs; [
  #     javaPackages.compiler.temurin-bin.jdk-25
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
      gradle
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
      # idea-wrapped
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
    packages = lib.concatLists (lib.attrValues pkgGroups);

    file = {
      ".ideavimrc".source = ../dotconfig/.ideavimrc;

      ".config/swappy" = {
        source = ../dotconfig/swappy;
        recursive = true;
      };
    };
  };
}
