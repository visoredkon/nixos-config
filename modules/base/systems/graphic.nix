{ pkgs, ... }:

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
        vpl-gpu-rt
        intel-media-driver
      ];
    };
  };

  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };

    systemPackages = with pkgs; [
      mesa-demos
      libva-utils
      vulkan-tools
    ];
  };
}
