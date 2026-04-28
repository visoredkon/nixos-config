{ ... }:

{
  imports = [
    ./cloudflare-warp.nix
    ./flatpak.nix
    ./irqbalance.nix
    ./ollama.nix
    ./openssh.nix
    ./udisk2.nix
    ./wireguard.nix
  ];
}
