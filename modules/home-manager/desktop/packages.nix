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

  antigravity-wrapped = mkWrappedApp {
    name = "antigravity";
    pkg = pkgs.antigravity;
    extraPkgs = with pkgs; [
      google-chrome
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

  lmstudio-wrapped = mkFhsApp {
    name = "lm-studio";
    pkg = pkgs-unstable.lmstudio;
  };

  vscode-wrapped = mkFhsApp {
    name = "code";
    pkg = pkgs-unstable.vscode.override {
      commandLineArgs = [ "--password-store=gnome-libsecret" ];
    };
  };

  pkgGroups = {
    communications = with pkgs; [
      discord
    ];

    devs = with pkgs; [
      postman

      antigravity-wrapped
      lmstudio-wrapped
      # idea-wrapped
      vscode-wrapped
      zed-editor
    ];

    entertainments = with pkgs; [
      spotify
    ];

    games = with pkgs; [
      blockbench
      hytale-launcher
    ];

    office = with pkgs; [
      (obsidian.override { commandLineArgs = "--password-store=gnome-libsecret"; })
      zotero
    ];

    cli-utils = with pkgs; [
      brightnessctl
      wl-clipboard
      grim
      slurp
      swappy
      libinput
      libinput-gestures
      libsForQt5.qt5.qtwayland
      kdePackages.qtwayland
    ];

    gui-utils = with pkgs; [
      libnotify
      persepolis
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
