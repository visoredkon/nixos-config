{
  inputs,
  pkgs,
  username,
  ...
}:
let
  retrieveZenCatppuccin =
    {
      file,
      sha256 ? "",
    }:
    builtins.readFile (
      builtins.fetchurl {
        inherit sha256;

        url = "https://raw.githubusercontent.com/catppuccin/zen-browser/refs/heads/main/themes/Mocha/Green/${file}";
      }
    );

in
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;

    nativeMessagingHosts = with pkgs; [
      tridactyl-native
    ];

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        name = "Default";

        extraConfig = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        '';

        userChrome = retrieveZenCatppuccin {
          file = "userChrome.css";
          sha256 = "sha256:03qd2bp4vjmg983n57bf2p36azbighcx67pwjhxap5q8rg23bac6";
        };
        userContent = retrieveZenCatppuccin {
          file = "userContent.css";
          sha256 = "sha256:0l551lp5ds09lx0v83vz2kvzahvjg9iz090y8qm6pc06nnn1llx9";
        };
      };
    };
  };

  home.file = {
    ".config/tridactyl" = {
      source = ../../dotconfig/tridactyl;
      recursive = true;
    };
  };

  xdg = {
    desktopEntries = {
      zen-browser = {
        name = "Zen Browser";
        genericName = "Web Browser";
        exec = "/etc/profiles/per-user/${username}/bin/zen-beta %U";

        noDisplay = true;
        terminal = false;
        type = "Application";

        categories = [
          "Network"
          "WebBrowser"
        ];
        mimeType = [
          "text/html"
          "application/pdf"
          "application/xhtml+xml"
          "application/xml"
        ];
      };
    };

    mimeApps = {
      defaultApplications = {
        "text/html" = "zen-browser.desktop";
        "application/pdf" = "zen-browser.desktop";
        "application/xhtml+xml" = "zen-browser.desktop";
        "application/xml" = "zen-browser.desktop";
        "x-scheme-handler/http" = "zen-browser.desktop";
        "x-scheme-handler/https" = "zen-browser.desktop";
        "x-scheme-handler/about" = "zen-browser.desktop";
      };
    };
  };
}
