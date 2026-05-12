{
  pkgs,
  pkgs-unstable,
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
    cloudflared
    ookla-speedtest
    sshfs
    wayvnc
    wget
    xh

    ffmpeg

    claude-code
    codebase-memory-mcp
    copilot-cli
    forgecode
    pkgs-unstable.gemini-cli
    kiro-cli
    opencode

    devenv
    mise
    # pvetui
    terraform

    fd
    fzf
    jq
    ripgrep
    tldr

    go
  ];
}
