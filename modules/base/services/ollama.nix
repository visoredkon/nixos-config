{ ... }:

{
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
  };

  networking.firewall.extraInputRules = ''
    ip saddr != 10.0.2.2 ip protocol tcp drop
  '';

  systemd.user.services.docker.serviceConfig.Environment = [
    "DOCKERD_ROOTLESS_ROOTLESSKIT_DISABLE_HOST_LOOPBACK=false"
  ];
}
