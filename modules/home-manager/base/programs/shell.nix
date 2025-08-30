{ pkgs, ... }:

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

        warp-cli generate-completions fish | source
      '';

      shellAliases = {
        n = "n";
        "n." = "n .";

        ze = "zellij";
      };
      shellAbbrs = {
        # NixUp
        config = "nixup config";

        config-lazygit = "nixup lazygit";
        config-log = "nixup log";
        config-sync = "nixup sync";

        config-apply = "nixup apply";
        config-boot = "nixup boot";
        config-test = "nixup test";

        mkdir = "mkdir -p";

        speedtest = "speedtest --progress=yes";
      };

      plugins = [
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair;
        }
        {
          name = "done";
          src = pkgs.fetchFromGitHub {
            owner = "franciscolourenco";
            repo = "done";
            rev = "0bfe402753681f705a482694fcaf20c2bfc6deb7";
            sha256 = "WA6DBrPBuXRIloO05UBunTJ9N01d6tO1K1uqojjO0mo=";
          };
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

      enableFishIntegration = true;
    };
  };

  home = {
    file.".config/fastfetch" = {
      source = ../../dotconfig/fastfetch;
      recursive = true;
    };
    file.".config/fish/functions/nixup.fish" = {
      source = ../../dotconfig/fish/functions/nixup.fish;
    };
  };
}
