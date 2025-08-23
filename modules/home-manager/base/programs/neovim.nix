{ pkgs, ... }:

{
  programs.neovim = {
    #
    enable = true;

    defaultEditor = true;

    extraPackages = with pkgs; [
      cargo
      clang
      go

      # LSP
      lua-language-server
      nixd
      hyprls

      # Linter
      nixpkgs-lint

      # Formatter
      stylua
      shfmt
      nixfmt-rfc-style
    ];
  };

  home = {
    file.".config/nvim" = {
      source = ../../dotconfig/nvim;
      recursive = true;
    };
  };
}
