{ stateVersion, ... }:

{
  imports = [
    ./systems

    ./packages.nix
    ./programs.nix

    ./services

    ./fonts.nix

    ./themes/catppuccin.nix
  ];

  system.stateVersion = stateVersion;
}
