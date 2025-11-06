{ config, ... }:

{
  programs.git = {
    enable = true;

    settings = {
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
        name = "Pahril";
        email = "88573655+visoredkon@users.noreply.github.com";

        signingKey = "${config.home.homeDirectory}/.ssh/github";
      };
    };
  };
}
