{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    extraPackages = with pkgs; [
      # Build Tools / Compilers
      cargo
      clang
      go

      # Runtime / Interpreters
      lua
      luarocks-nix
      nodejs
      temurin-bin-21

      # Image / Graphics
      ghostscript
      imagemagick

      # Document / Typesetting
      mermaid-cli
      tectonic
      typstyle

      # LSP Servers
      bash-language-server
      basedpyright
      fish-lsp
      marksman
      vscode-langservers-extracted
      docker-language-server
      gopls
      hyprls
      intelephense
      jdt-language-server
      lua-language-server
      nixd
      terraform-ls
      typescript-go
      typescript-language-server
      vscode-json-languageserver
      yaml-language-server

      # Linters
      actionlint
      deadnix
      markdownlint-cli2
      selene
      shellcheck
      statix
      yamllint
      hadolint
      ruff
      tflint

      # Formatters
      biome
      dprint
      taplo
      yamlfmt
      gofumpt
      nixfmt
      shfmt
      stylua

      # Others
      sqlite
      tinymist
      tree-sitter
      trash-cli
      websocat
    ];
  };

  xdg.configFile = {
    "nvim/init.lua" = lib.mkForce {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/nvim/init.lua";
    };
    "nvim/lazyvim.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/nvim/lazyvim.json";
    };
    "nvim/stylua.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/nvim/stylua.toml";
    };
    "nvim/lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/nvim/lua";
    };
  };
}
