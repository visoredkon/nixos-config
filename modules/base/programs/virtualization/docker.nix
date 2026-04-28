{
  pkgs,
  ...
}:
let
  daemonSettings = {
    dns = [
      "1.1.1.2"
      "1.0.0.2"
      "2606:4700:4700::1112"
      "2606:4700:4700::1002"
    ];
    ipv6 = true;
  };
in
{
  virtualisation.docker = {
    enable = true;
    daemon.settings = daemonSettings;

    rootless = {
      enable = true;
      daemon.settings = daemonSettings;

      setSocketVariable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      docker-buildx
    ];

    pathsToLink = [ "/libexec" ];

    variables = {
      DOCKER_CLI_PLUGIN_DIRECTORY = "/run/current-system/sw/libexec/docker/cli-plugins";
    };
  };
}
