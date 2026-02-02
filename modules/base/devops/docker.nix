{
  pkgs,
  ...
}:

{
  virtualisation.docker = {
    enable = false;

    rootless = {
      enable = true;

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
