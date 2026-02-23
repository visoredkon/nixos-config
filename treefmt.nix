{
  pkgs,
  ...
}:

{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;

    shfmt = {
      enable = true;
      indent_size = 2;
    };

    stylua.enable = true;

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
      "secrets/nixu/**"
      "secrets/rune/**"
      "flake.lock"
    ];

    formatter.fish_indent = {
      command = "${pkgs.fish}/bin/fish_indent";
      options = [ "--write" ];
      includes = [ "*.fish" ];
    };
  };
}
