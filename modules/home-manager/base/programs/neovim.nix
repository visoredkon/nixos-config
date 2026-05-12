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
      lua5_1
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
      basedpyright
      docker-language-server
      gopls
      hyprls
      intelephense
      jdt-language-server
      lua-language-server
      nixd
      pyright
      terraform-ls
      typescript-language-server
      vscode-json-languageserver
      yaml-language-server

      # Linters
      deadnix
      hadolint
      ruff
      tflint

      # Formatters
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
