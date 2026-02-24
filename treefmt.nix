{
  pkgs,
  ...
}:

{
  projectRootFile = "flake.nix";

  programs = {
    dprint = {
      enable = true;
      includes = [
        "**/*.json"
        "**/*.jsonc"
        "**/*.md"
      ];
      settings = {
        lineWidth = 120;
        plugins = pkgs.dprint-plugins.getPluginList (
          p: with p; [
            dprint-plugin-json
            dprint-plugin-markdown
          ]
        );
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
