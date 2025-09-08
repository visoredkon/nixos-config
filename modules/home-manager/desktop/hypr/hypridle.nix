{ ... }:

{
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display
      };

      listener = [
        {
          timeout = 150; # 2.5min
          on-timeout = "brightnessctl -s set 0";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "hyprlock";
          on-resume = "notify-send \"Welcome back!\"";
        }
      ];
    };
  };
}
