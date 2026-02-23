{
  stateVersion,
  ...
}:

{
  imports = [
    ./systems

    ./packages.nix
    ./programs

    ./services

    ./fonts.nix

    ./themes/catppuccin.nix

    ./sops.nix
  ];

  system.stateVersion = stateVersion;
}
