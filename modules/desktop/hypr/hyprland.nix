{
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  hypr = inputs.hyprland.packages.${system};
in
{
  programs = {
    uwsm.enable = true;

    hyprland = {
      enable = true;
      package = hypr.hyprland;
      portalPackage = hypr.xdg-desktop-portal-hyprland;

      withUWSM = true;
      xwayland.enable = true;
    };
  };
}
