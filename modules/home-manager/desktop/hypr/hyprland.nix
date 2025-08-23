{ config, pkgs, ... }:
let
  homeDirectory = config.home.homeDirectory;
in
{
  xdg = {
    # uwsm users should avoid placing environment variables in the hyprland.conf file.
    # Instead, use ~/.config/uwsm/env for theming, xcursor, Nvidia and toolkit variables, and ~/.config/uwsm/env-hyprland for HYPR* and AQ_* variables.
    # The format is export KEY=VAL.
    configFile."uwsm/env" = {
      source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    };

    mime = {
      enable = true;
    };

    mimeApps = {
      enable = true;
    };

    userDirs = {
      enable = true;

      createDirectories = true;

      desktop = "${homeDirectory}/Desktop";
      documents = "${homeDirectory}/Documents";
      download = "${homeDirectory}/Downloads";
      pictures = "${homeDirectory}/Pictures";
      videos = "${homeDirectory}/Videos";
    };

    portal = {
      enable = true;

      config = {
        hyprland-portals = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = "kde";
        };
      };
      xdgOpenUsePortal = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };
  };

  home = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";

      # Use Wayland if available; if not, try X11 and then any other GDK backend.
      # (https://wiki.hypr.land/Configuring/Environment-variables/)
      GDK_BACKEND = "wayland,*";
      QT_QPA_PLATFORM = "wayland";
      # (https://doc.qt.io/qt-5/highdpi.html) enables automatic scaling, based on the monitor’s pixel density
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      SDL_VIDEODRIVER = "wayland";
    };
  };
}
