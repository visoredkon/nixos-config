{ ... }:
{
  imports = [
    ./kernel.nix
    ./firmware.nix
    ./locale.nix
    ./networking.nix
    ./security.nix
    ./users.nix

    ./audio.nix
    ./bluetooth.nix
    ./graphic.nix
    ./nix.nix
    ./power.nix
    ./shell.nix
    ./zram.nix
  ];
}
