{
  pkgs,
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

  home = {
    file.".config/nvim" = {
      enable = true;

      force = true;
      source = ../../dotconfig/nvim;
      recursive = true;
    };
  };
}
