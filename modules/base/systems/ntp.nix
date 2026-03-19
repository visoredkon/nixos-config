{ ... }:

{
  networking = {
    timeServers = [
      "time.cloudflare.com"
      "ptbtime1.ptb.de"
      "ptbtime4.ptb.de"
      "nts.netnod.se"
    ];
  };

  services = {
    timesyncd.enable = false; # "Whether to synchronise your machine’s time using chrony. Make sure you disable NTP if you enable this service."
    chrony = {
      enable = true;
      enableNTS = true;
    };
  };
}
