{ config, ... }:

{
  nix.extraOptions = ''
    !include ${config.home.homeDirectory}/.config/nix/access-tokens.conf
  '';
}
