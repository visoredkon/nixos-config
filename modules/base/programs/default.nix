{ ... }:

{
  imports = [
    ./dconf.nix
    ./nix-ld.nix
    ./nixos-cli.nix

    ./virtualization
  ];
}
