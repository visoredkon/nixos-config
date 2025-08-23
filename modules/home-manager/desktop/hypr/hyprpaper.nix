{ ... }:
let
  wallpaper = "${../assets/images/wallpapers/madara.jpg}";
in
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = true;
      splash = true;

      preload = [
        wallpaper
      ];

      wallpaper = [
        ", ${wallpaper}"
      ];
    };
  };
}
