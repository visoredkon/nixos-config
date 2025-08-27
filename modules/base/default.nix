{ stateVersion, ... }:

{
  imports = [
    ./systems

    ./packages.nix
    ./programs

    ./services

    ./fonts.nix

    ./themes/catppuccin.nix
  ];

  system.stateVersion = stateVersion;
}
