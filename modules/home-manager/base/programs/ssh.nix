{ config, ... }:

{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;
    hashKnownHosts = true;

    matchBlocks = {
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = "${config.home.homeDirectory}/.ssh/github";
      };
    };
  };
}
