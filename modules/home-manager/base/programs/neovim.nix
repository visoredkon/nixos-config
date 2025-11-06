{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    extraPackages = with pkgs; [
      cargo
      clang
      go
      lua5_1
      luarocks-nix
      nodejs
      temurin-bin-21

      graphviz
      imagemagick
      tinymist
      tree-sitter
      websocat

      # LSP
      # docker-language-server
      gopls
      intelephense
      lua-language-server
      nixd
      hyprls
      basedpyright
      vscode-json-languageserver
      yaml-language-server

      # Linter
      hadolint
      nixpkgs-lint
      ruff

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
