{ pkgs, ... }:

{
  fonts = {
    fontconfig = {
      enable = true;

      antialias = true;
      hinting = {
        enable = true;
        autohint = true;
      };

      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };

    packages = with pkgs; [
      font-awesome

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      nerd-fonts.jetbrains-mono
    ];
  };
}
