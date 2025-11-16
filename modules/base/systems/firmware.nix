{ pkgs, ... }:

{
  hardware = {
    enableRedistributableFirmware = true;

    firmware = with pkgs; [
      linux-firmware
      sof-firmware
    ];
  };
}
