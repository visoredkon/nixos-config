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

        set -l HM_VARS /etc/profiles/per-user/pahril/etc/profile.d/hm-session-vars.fish
        if test -f "$HM_VARS"
          set -l target (readlink "$HM_VARS")
          if test "$target" != "$__HM_SESS_VARS_TARGET"
            set -g __HM_SESS_VARS_SOURCED ""
            source "$HM_VARS"
            set -gx __HM_SESS_VARS_TARGET "$target"
          end
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
