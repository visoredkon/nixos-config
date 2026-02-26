{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  zenPackage = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta;
  zenDesktopFile = zenPackage.meta.desktopFileName;

  # retrieveZenCatppuccin =
  #   {
  #     file,
  #     sha256 ? "",
  #   }:
  #   builtins.readFile (
  #     builtins.fetchurl {
  #       inherit sha256;
  #
  #       url = "https://raw.githubusercontent.com/catppuccin/zen-browser/refs/heads/main/themes/Mocha/Green/${file}";
  #     }
  #   );
in
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    suppressXdgMigrationWarning = true;

    nativeMessagingHosts = with pkgs; [
      tridactyl-native
    ];

    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxStudies = true;
      DisableFeedbackCommands = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        name = "Default";

        # Alternative: `profiles.default.settings` can replace extraConfig with a more idiomatic attrset syntax
        extraConfig = ''
          // Declutter & UX
          user_pref("browser.aboutConfig.showWarning", true);
          user_pref("browser.compactmode.show", true);
          user_pref("browser.download.open_pdf_attachments_inline", true);
          user_pref("browser.newtabpage.activity-stream.showSponsored", false);
          user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
          user_pref("browser.tabs.crashReporting.sendReport", false);
          user_pref("browser.tabs.warnOnClose", true);
          user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
          user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
          user_pref("browser.urlbar.trimHttps", false);
          user_pref("browser.urlbar.trimURLs", false);
          user_pref("extensions.pocket.enabled", false);
          user_pref("findbar.highlightAll", true);
          user_pref("full-screen-api.warning.timeout", 0);
          user_pref("layout.word_select.eat_space_to_next_word", false);
          user_pref("middlemouse.paste", true);
          user_pref("permissions.default.desktop-notification", 2);
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("ui.key.menuAccessKey", 0);

          // Performance
          user_pref("browser.cache.disk.enable", false);
          user_pref("browser.cache.memory.capacity", -1);
          user_pref("gfx.webrender.all", true);
          user_pref("image.mem.decode_bytes_at_a_time", 131072);
          user_pref("layers.gpu-process.enabled", true);

          // Privacy & Security
          user_pref("beacon.enabled", false);
          user_pref("browser.contentblocking.category", "strict");
          user_pref("browser.safebrowsing.remoteLookups", false);
          user_pref("browser.send_pings", false);
          user_pref("datareporting.healthreport.uploadEnabled", false);
          user_pref("device.sensors.enabled", false);
          user_pref("dom.battery.enabled", false);
          user_pref("dom.security.https_only_mode", true);
          user_pref("dom.security.https_only_mode_ever_enabled", true);
          user_pref("geo.enabled", false);
          user_pref("media.video_stats.enabled", false);
          user_pref("network.cookie.cookieBehavior", 5);
          user_pref("network.dns.disablePrefetch", true);
          user_pref("network.http.referer.XOriginTrimmingPolicy", 2);
          user_pref("network.IDN_show_punycode", true);
          user_pref("network.predictor.enabled", false);
          user_pref("network.prefetch-next", false);
          user_pref("privacy.firstparty.isolate", false);
          user_pref("privacy.partition.network_state", true);
          user_pref("privacy.partition.serviceWorkers", true);
          user_pref("privacy.trackingprotection.socialtracking.enabled", true);
          user_pref("security.mixed_content.block_display_content", true);
          user_pref("security.ssl.require_safe_negotiation", true);
          user_pref("security.tls.version.min", 3);
          user_pref("toolkit.telemetry.enabled", false);
        '';

        # userChrome = retrieveZenCatppuccin {
        #   file = "userChrome.css";
        #   sha256 = "sha256:1nz7305bys8h8hycmwgifzc2lwvydzri3zqg9dxadd9jsm4800bn";
        # };
        # userContent = retrieveZenCatppuccin {
        #   file = "userContent.css";
        #   sha256 = "sha256:0l551lp5ds09lx0v83vz2kvzahvjg9iz090y8qm6pc06nnn1llx9";
        # };
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
        exec = "${lib.getExe zenPackage} %U";

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

    mimeApps =
      let
        associations = builtins.listToAttrs (
          map
            (name: {
              inherit name;
              value = zenDesktopFile;
            })
            [
              "text/html"
              "text/plain"
              "application/json"
              "application/pdf"
              "application/xml"
              "application/xhtml+xml"
              "application/x-extension-htm"
              "application/x-extension-html"
              "application/x-extension-xht"
              "application/x-extension-xhtml"
              "application/x-extension-shtml"
              "x-scheme-handler/http"
              "x-scheme-handler/https"
              "x-scheme-handler/about"
              "x-scheme-handler/chrome"
              "x-scheme-handler/unknown"
            ]
        );
      in
      {
        associations.added = associations;
        defaultApplications = associations;
      };
  };
}
