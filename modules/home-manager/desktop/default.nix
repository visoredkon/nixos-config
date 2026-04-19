{ ... }:

{
  imports = [
    ../base

    ./packages.nix
    ./programs

    ./services

    ./hypr

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
