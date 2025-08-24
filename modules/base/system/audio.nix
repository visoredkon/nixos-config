{ pkgs, ... }:

{
  services = {
    pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
      # jack = {
      #   enable = true;
      # };
      pulse = {
        enable = true;
      };
      wireplumber = {
        enable = true;
      };
    };
  };

  hardware.firmware = with pkgs; [
    sof-firmware
  ];
}
