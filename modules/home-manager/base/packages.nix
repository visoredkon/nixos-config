{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ffmpeg

    aria2
    fd
    fzf
    ripgrep
    tldr
    sshfs
    xh

    lsof
    usbutils
    unzip
    wget
    xz
    zip

    ookla-speedtest
  ];
}
