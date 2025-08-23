{ ... }:

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
      ".config/hypr" = {
        source = ../../dotconfig/hypr;
        recursive = true;
      };
      ".config/hypr/mocha.conf" = {
        text = builtins.readFile (
          builtins.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/hyprland/refs/heads/main/themes/mocha.conf";
            sha256 = "sha256:0513j8wbh50jah2r0h48sw9jfw8w0h6w8z90vg0f6zk3jsyls5ab";
          }
        );
      };
    };
  };
}
