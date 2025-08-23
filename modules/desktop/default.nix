{ ... }:

{
  imports = [
    ./packages.nix

    ./services.nix

    ./hypr/hyprland.nix

    ./display-manager.nix
  ];
}
