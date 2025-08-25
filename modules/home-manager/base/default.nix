{ username, stateVersion, ... }:

{
  imports = [
    ./packages.nix
    ./programs

    ./services

    ./themes/catppuccin.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # allowUnfreePredicate = (_: true);
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
