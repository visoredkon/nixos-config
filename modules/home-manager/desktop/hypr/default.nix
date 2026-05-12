{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix

    ./hyprlock.nix
    ./hypridle.nix

    ./hyprpolkitagent.nix
  ];

  home = {
    file = {
      ".config/nixos-config/modules/home-manager/dotconfig/hypr/.luarc.json" = {
        text = builtins.toJSON {
          diagnostics = {
            globals = [
              "hl"
            ];
          };
          workspace = {
            library = [
              "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/share/hypr/stubs"
            ];
          };
        };
      };

      ".config/hypr/.luarc.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/hypr/.luarc.json";
      };
      ".config/hypr/hyprland.conf" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/hypr/hyprland.conf";
      };
      ".config/hypr/hyprland" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/hypr/hyprland";
      };
    };
  };
}
