{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  zenPackage = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta;

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
    setAsDefaultBrowser = true;

    nativeMessagingHosts = with pkgs; [
      tridactyl-native
    ];

    policies = lib.mkForce { };

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        name = "Default";

        # Alternative: `profiles.default.settings` can replace extraConfig with a more idiomatic attrset syntax
        extraConfig = ''
          // Declutter & UX
          user_pref("app.update.enabled", false);
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
          user_pref("app.normandy.enabled", false);
          user_pref("app.shield.optoutstudies.enabled", false);
          user_pref("beacon.enabled", false);
          user_pref("browser.contentblocking.category", "custom");
          user_pref("browser.places.speculativeConnect.enabled", false);
          user_pref("browser.safebrowsing.downloads.enabled", true);
          user_pref("browser.safebrowsing.downloads.remote.enabled", true);
          user_pref("browser.safebrowsing.enabled", true);
          user_pref("browser.safebrowsing.malware.enabled", true);
          user_pref("browser.safebrowsing.phishing.enabled", true);
          user_pref("browser.safebrowsing.remoteLookups", false);
          user_pref("browser.send_pings", false);
          user_pref("datareporting.healthreport.uploadEnabled", false);
          user_pref("datareporting.policy.dataSubmissionEnabled", false);
          user_pref("device.sensors.enabled", false);
          user_pref("dom.battery.enabled", false);
          user_pref("dom.security.https_only_mode", true);
          user_pref("dom.security.https_only_mode_ever_enabled", true);
          user_pref("dom.security.https_only_mode_send_http_background_request", false);
          user_pref("extensions.formautofill.addresses.enabled", true);
          user_pref("extensions.formautofill.creditCards.available", false);
          user_pref("extensions.formautofill.creditCards.enabled", false);
          user_pref("geo.enabled", false);
          user_pref("media.video_stats.enabled", false);
          user_pref("network.captive-portal-service.enabled", false);
          user_pref("network.connectivity-service.enabled", false);
          user_pref("network.cookie.cookieBehavior", 5);
          user_pref("network.dns.disablePrefetch", true);
          user_pref("network.dns.disablePrefetchFromHTTPS", true);
          user_pref("network.http.referer.XOriginTrimmingPolicy", 2);
          user_pref("network.http.speculative-parallel-limit", 0);
          user_pref("network.IDN_show_punycode", true);
          user_pref("network.predictor.enabled", false);
          user_pref("network.prefetch-next", false);
          user_pref("network.trr.bootstrapAddress", "1.1.1.2");
          user_pref("network.trr.custom_uri", "https://security.cloudflare-dns.com/dns-query");
          user_pref("network.trr.mode", 1);
          user_pref("privacy.firstparty.isolate", false);
          user_pref("privacy.partition.network_state", true);
          user_pref("privacy.partition.serviceWorkers", true);
          user_pref("privacy.trackingprotection.cryptomining.enabled", true);
          user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
          // threads.com breaks when true
          user_pref("privacy.trackingprotection.socialtracking.enabled", false);
          user_pref("security.mixed_content.block_display_content", true);
          user_pref("security.OCSP.require", true);
          user_pref("security.pki.crlite_mode", 2);
          user_pref("security.remote_settings.crlite_filters.enabled", true);
          user_pref("security.ssl.require_safe_negotiation", true);
          user_pref("security.tls.enable_0rtt_data", false);
          user_pref("security.tls.version.min", 3);
          user_pref("signon.autofillForms", false);
          user_pref("signon.formlessCapture.enabled", false);
          user_pref("signon.rememberSignons", false);
          user_pref("toolkit.telemetry.archive.enabled", false);
          user_pref("toolkit.telemetry.bhrPing.enabled", false);
          user_pref("toolkit.telemetry.enabled", false);
          user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
          user_pref("toolkit.telemetry.newProfilePing.enabled", false);
          user_pref("toolkit.telemetry.server", "data:,");
          user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
          user_pref("toolkit.telemetry.unified", false);
          user_pref("toolkit.telemetry.updatePing.enabled", false);
        '';

        userChrome = retrieveZenCatppuccin {
          file = "userChrome.css";
          sha256 = "sha256:1nz7305bys8h8hycmwgifzc2lwvydzri3zqg9dxadd9jsm4800bn";
        };
        userContent = retrieveZenCatppuccin {
          file = "userContent.css";
          sha256 = "sha256:0l551lp5ds09lx0v83vz2kvzahvjg9iz090y8qm6pc06nnn1llx9";
        };
      };
    };
  };

  home.file = {
    ".config/tridactyl/tridactylrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/modules/home-manager/dotconfig/tridactyl/tridactylrc";
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
  };
}
