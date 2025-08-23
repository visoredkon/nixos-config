{ stateVersion, ... }:

{
  imports = [
    ./system/boot.nix
    ./system/locale.nix
    ./system/networking.nix
    ./system/security.nix

    ./system/audio.nix
    ./system/battery.nix
    ./system/bluetooth.nix
    ./system/graphic.nix
    ./system/nix.nix

    ./system/shell.nix
    ./system/users.nix

    ./packages.nix
    ./programs.nix

    ./services/nixos-cli.nix
    ./services/openssh.nix

    ./fonts.nix

    ./themes/catppuccin.nix
  ];

  system.stateVersion = stateVersion;
}
