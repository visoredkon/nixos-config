{ config, ... }:

{
  programs.git = {
    enable = true;

    userName = "Pahril";
    userEmail = "88573655+visoredkon@users.noreply.github.com";

    extraConfig = {
      commit = {
        gpgsign = true;
      };

      init = {
        defaultBranch = "main";
      };

      gpg = {
        format = "ssh";
      };

      push = {
        gpgSign = false;
      };

      tag = {
        gpgSign = true;
      };

      user = {
        signingKey = "${config.home.homeDirectory}/.ssh/github";
      };
    };
  };
}
