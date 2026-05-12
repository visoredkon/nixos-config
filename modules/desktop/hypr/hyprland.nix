{
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.hyprland.nixosModules.default ];

  environment.systemPackages = with pkgs; [
    hyprshutdown
  ];

  programs = {
    uwsm.enable = true;

    hyprland = {
      enable = true;

      withUWSM = true;
      xwayland.enable = true;
    };
  };
}
