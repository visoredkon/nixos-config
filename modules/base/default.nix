{ stateVersion, ... }:

{
  imports = [
    ./systems

    ./packages.nix
    ./programs

    ./services

    ./fonts.nix

    ./devops

    ./themes/catppuccin.nix
  ];

  system.stateVersion = stateVersion;
}
