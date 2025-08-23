{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ffmpeg

    fd
    fzf
    ripgrep
    tldr

    unzip
    wget
    xz
    zip
  ];
}
