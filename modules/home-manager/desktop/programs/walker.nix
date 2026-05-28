{
  config,
  inputs,
  pkgs,
  ...
}:

let
  catppuccinMochaStyle = builtins.readFile (
    builtins.fetchurl {
      url = "https://raw.githubusercontent.com/krymancer/walker/main/themes/catppuccin-mocha/style.css";
      sha256 = "0l2jv0q9v9cd17ahbjd50wg7fpjqxgmap7d7m5yshyfl2px04svy";
    }
  );
in

{
  imports = [ inputs.walker.homeManagerModules.default ];

  home.packages = with pkgs; [ netcat ];

  programs.walker = {
    enable = true;
    runAsService = true;
    config = { };
    themes."catppuccin-mocha" = {
      style = catppuccinMochaStyle;
    };
  };

  home.file = {
    ".config/walker/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/walker/config.toml";

    ".config/elephant/clipboard.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/elephant/clipboard.toml";

    ".config/elephant/menus/brightness.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/elephant/menus/brightness.lua";

    ".config/elephant/menus/nerdfont.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/elephant/menus/nerdfont.lua";

    ".config/elephant/menus/obsidian.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/elephant/menus/obsidian.lua";

    ".config/elephant/menus/volume.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/elephant/menus/volume.lua";
  };
}
