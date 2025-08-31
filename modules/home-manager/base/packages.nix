{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ffmpeg

    fd
    fzf
    ripgrep
    tldr

    usbutils
    unzip
    wget
    xz
    zip

    # devenv
    ookla-speedtest
  ];
}
