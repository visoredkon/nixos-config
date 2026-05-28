{
  pkgs,
  ...
}:

{
  projectRootFile = "flake.nix";

  programs = {
    biome = {
      enable = true;
      includes = [
        "**/*.json"
        "**/*.jsonc"
      ];
    };

    prettier = {
      enable = true;
      includes = [
        "**/*.md"
      ];
      settings = {
        printWidth = 120;
      };
    };

    nixfmt.enable = true;

    shfmt = {
      enable = true;
      indent_size = 2;
    };

    stylua = {
      enable = true;
      settings = {
        column_width = 120;
        indent_type = "Spaces";
        indent_width = 2;
      };
    };

    taplo.enable = true;

    yamlfmt = {
      enable = true;
      settings = {
        formatter = {
          type = "basic";
          retain_line_breaks = true;
        };
      };
    };
  };

  settings = {
    global.excludes = [
      "**/*.jpg"
      "**/*.png"
      "**/*.pub"
      "flake.lock"
      "secrets/nixu/**"
      "secrets/rune/**"
    ];

    formatter.fish_indent = {
      command = "${pkgs.fish}/bin/fish_indent";
      options = [ "--write" ];
      includes = [ "*.fish" ];
    };
  };
}
