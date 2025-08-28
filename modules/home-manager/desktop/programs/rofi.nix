{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;

    pass = {
      enable = true;

      package = pkgs.rofi-pass-wayland;

      stores = [
        "$HOME/.password-store"
      ];
    };
  };
}
