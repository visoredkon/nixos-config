{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ffmpeg

    fd
    fzf
    ripgrep
    tldr
    sshfs

    lsof
    usbutils
    unzip
    wget
    xz
    zip

    devenv
    ookla-speedtest
  ];
}
