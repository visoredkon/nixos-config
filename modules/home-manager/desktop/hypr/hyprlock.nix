{ ... }:

{
  programs.hyprlock = {
    enable = true;

    # settings = {
    #   # background = lib.mkForce [
    #   #   {
    #   #     blur_passes = 5;
    #   #     color = "rgb(1e1e2e)";
    #   #     path = "${../assets/images/wallpapers/madara.jpg}";
    #   #   }
    #   # ];
    # };
  };

  home = {
    file = {
      ".face" = {
        source = ../assets/images/ubel.jpg;
      };
      ".config/background" = {
        source = ../assets/images/wallpapers/madara.jpg;
      };
      # ".config/hypr/hyprlock.conf" = {
      #   text = builtins.readFile (
      #     builtins.fetchurl {
      #       url = "https://raw.githubusercontent.com/catppuccin/hyprlock/refs/heads/main/hyprlock.conf";
      #       sha256 = "sha256:0513j8wbh50jah2r0h48sw9jfw8w0h6w8z90vg0f6zk3jsyls5ab";
      #     }
      #   );
      # };
    };
  };
}
