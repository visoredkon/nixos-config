{ stateVersion, ... }:

{
  imports = [
    ./system/boot.nix
    ./system/firmware.nix
    ./system/locale.nix
    ./system/networking.nix
    ./system/security.nix

    ./system/audio.nix
    ./system/bluetooth.nix
    ./system/graphic.nix
    ./system/nix.nix
    ./system/power.nix

    ./system/shell.nix
    ./system/users.nix

    ./packages.nix
    ./programs.nix

    ./services

    ./fonts.nix

    ./themes/catppuccin.nix
  ];

  system.stateVersion = stateVersion;
}
