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
      websocat

      # LSP
      gopls
      intelephense
      lua-language-server
      nixd
      hyprls

      # Linter
      nixpkgs-lint
      tinymist

      # Formatter
      gofumpt
      stylua
      shfmt
      typstyle
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
