{
  config,
  pkgs,
  ...
}:

{
  programs = {
    fish = {
      enable = true;

      generateCompletions = true;

      interactiveShellInit = ''
        set -g fish_greeting

        if test "$TERM" = "xterm-kitty"
          fastfetch
        end

        batman --export-env | source

        mise activate fish | source

        warp-cli generate-completions fish | source
      '';

      shellAliases = {
        ap = "${../../dotconfig/scripts/ap.sh}";
        cfw = "${../../dotconfig/scripts/cloudflare-warp.sh}";

        proxmox-qemu = "${config.home.homeDirectory}/Data/Codes/lab/thesis/virtualization/proxmox-qemu.sh";

        ze = "zellij";
      };
      shellAbbrs = {
        config = "nixup config";

        n = "nvim";
        "n." = "nvim .";

        mkdir = "mkdir -p";
      };

      plugins = [
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair;
        }
        {
          name = "done";
          src = pkgs.fishPlugins.done;
        }
        {
          name = "fifc";
          src = pkgs.fishPlugins.fifc;
        }
      ];
    };

    bat = {
      enable = true;

      extraPackages = with pkgs.bat-extras; [
        core
      ];
    };

    fastfetch = {
      enable = true;
    };

    starship = {
      enable = true;
    };
  };

  home = {
    file = {
      ".config/starship.toml".source = ../../dotconfig/starship.toml;
      ".config/fastfetch" = {
        source = ../../dotconfig/fastfetch;
        recursive = true;
      };
      ".config/fish/functions/nixup.fish".source = ../../dotconfig/fish/functions/nixup.fish;
    };
  };
}
