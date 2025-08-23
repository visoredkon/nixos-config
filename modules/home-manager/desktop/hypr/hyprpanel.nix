{ ... }:

{
  programs.hyprpanel = {
    enable = false;

    systemd.enable = true;

    dontAssertNotificationDaemons = true;

    settings = {
      bar = {
        clock = {
          format = "%a %b %d %I:%M %p";
        };
        launcher = {
          autoDetectIcon = true;
        };
        media = {
          show_active_only = true;
        };
        network = {
          showWifiInfo = true;
        };
        systray = {
          ignore = [
            "blueman"
          ];
        };
        workspaces = {
          monitorSpecific = false;
          show_icons = false;
          show_numbered = true;
          workspaces = 1;
        };
      };

      menus = {
        clock = {
          time = {
            military = true;
          };
        };
        dashboard = {
          directories = {
            enabled = false;
          };
        };
      };

      theme = {
        bar = {
          floating = true;
          transparent = false;

          opacity = 50;
          buttons = {
            opacity = 85;
          };
          menus = {
            opacity = 80;
          };
        };
        font = {
          size = "10px";
        };
        osd = {
          location = "top right";
          orientation = "horizontal";
        };
      };

      bar = {
        layouts = {
          "*" = {
            left = [
              "dashboard"
              # "windowtitle"
              "media"
            ];
            middle = [
              "workspaces"
            ];
            right = [
              "volume"
              "network"
              "bluetooth"
              "battery"
              "clock"
              "systray"
              "notifications"
            ];
          };
        };
      };
    };
  };
}
