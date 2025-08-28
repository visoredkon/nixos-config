{ ... }:

{
  imports = [
    ./packages.nix
    ./programs.nix

    ./services.nix

    ./hypr/hyprland.nix

    ./display-manager.nix
  ];
}
