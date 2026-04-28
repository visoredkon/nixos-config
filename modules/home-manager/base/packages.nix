{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    p7zip
    unzip
    xz
    zip

    gdu
    lsof
    usbutils

    aria2
    ookla-speedtest
    sshfs
    wget
    xh

    ffmpeg

    devenv
    forgecode
    gemini-cli-bin
    mise
    opencode

    fd
    fzf
    jq
    ripgrep
    tldr
  ];
}
