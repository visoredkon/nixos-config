{
  pkgs,
  ...
}:

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

    gdu
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
