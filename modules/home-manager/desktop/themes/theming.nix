{ pkgs, ... }:

{
  gtk = {
    enable = true;

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
    font = {
      name = "Noto Sans";
      size = 8;
    };
    theme = {
      name = "Adwaita-dark";
    };
  };

  qt = {
    enable = true;

    platformTheme = {
      name = "kvantum";
    };
    style = {
      name = "kvantum";
    };
  };
}
