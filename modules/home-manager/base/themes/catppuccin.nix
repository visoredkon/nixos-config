{ inputs, ... }:

{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin = {
    enable = false;

    accent = "green";
    flavor = "mocha";

    bat = {
      enable = true;
    };
    btop = {
      enable = true;
    };
    fcitx5 = {
      enable = true;
    };
    fish = {
      enable = true;
    };
    fzf = {
      enable = true;
    };
    lazygit = {
      enable = true;
    };
    waybar = {
      enable = false;
    };
    yazi = {
      enable = true;
    };
    zellij = {
      enable = true;
    };
  };
}
