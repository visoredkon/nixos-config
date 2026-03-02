{ ... }:

{
  imports = [
    ./cloudflare-warp.nix
    ./flatpak.nix
    ./irqbalance.nix
    ./openssh.nix
    ./wireguard.nix
  ];
}
