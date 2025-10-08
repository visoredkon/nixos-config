{ pkgs, pkgs-main, ... }:

{
  boot = {
    kernelParams = [
      "i915.force_probe=46a8" # nix run nixpkgs#pciutils -- -nn | rg VGA
    ];
  };
  hardware = {
    graphics = {
      enable = true;

      extraPackages = with pkgs; [
        pkgs-main.libvdpau-va-gl
        intel-media-driver
        vpl-gpu-rt
      ];
    };
  };

  environment = {
    sessionVariables = {
      ANV_DEBUG = "video-decode,video-encode";
      LIBVA_DRIVER_NAME = "iHD";
      VDPAU_DRIVER = "va_gl";
    };

    systemPackages = with pkgs; [
      mesa-demos
      libva-utils
      vdpauinfo
      vulkan-tools
    ];
  };
}
