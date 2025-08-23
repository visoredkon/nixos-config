{ ... }:

{
  imports = [
    ../base

    ./packages.nix
    ./programs

    ./services.nix

    ./hypr

    # ./themes/theming.nix
    ./themes/stylix.nix
    ./themes/catppuccin.nix
  ];

  home = {
    file = {
      ".home-manager/images" = {
        source = ./assets/images;
        recursive = true;
      };
    };
  };
}
