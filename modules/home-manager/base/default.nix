{
  lib,
  username,
  stateVersion,
  ...
}:

{
  imports = [
    ./packages.nix
    ./programs

    ./services

    ./themes/catppuccin.nix
  ];

  nixpkgs = {
    config = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "discord"
          "obsidian"
          "phpstorm"
          "spotify"
          "vscode"
        ];
    };
  };

  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";

    sessionVariables = {
      NIXOS_CONFIG = "/home/${username}/.config/nixos-config";
    };

    shell.enableFishIntegration = true;
  };
}
