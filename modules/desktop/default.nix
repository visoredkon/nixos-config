{ ... }:

{
  imports = [
    ./packages.nix
    ./programs

    ./services.nix

    ./hypr/hyprland.nix

    ./display-manager.nix
  ];
}
