{
  username,
  ...
}:

{
  services = {
    pipewire = {
      enable = true;

      alsa = {
        enable = true;
      };
      # jack = {
      #   enable = true;
      # };
      pulse = {
        enable = true;
      };
      wireplumber = {
        enable = true;

        extraConfig = {
          # bluetoothEnhancements = {
          #   "monitor.bluez.properties" = {
          #   };
          # };

          pipewire."92-low-latency" = {
            "context.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.quantum" = 32;
              "default.clock.min-quantum" = 32;
              "default.clock.max-quantum" = 1024;
            };
          };
        };
      };
    };
  };

  users.users.${username} = {
    extraGroups = [
      "audio"
    ];
  };
}
