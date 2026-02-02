{ ... }:
let
  wallpaper = "${../assets/images/wallpapers/madara.jpg}";
in
{
  services.hyprpaper = {
    enable = true;

    settings = {
      wallpaper = {
        monitor = "";
        path = wallpaper;
      };
    };
  };
}
