{ ... }:

{
  imports = [
    ./cloudflare-warp.nix
    # ./cloudflared.nix
    ./flatpak.nix
    ./irqbalance.nix
    ./openssh.nix
    ./tailscale.nix
    ./udisk2.nix
    ./wireguard.nix
  ];
}
