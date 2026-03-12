{
  config,
  sshLib,
  ...
}:
let
  inherit (sshLib) sshSecretsPath sshPubKeysPath mkPubKeyLink;
in
{
  home.file = {
    ".ssh/github/authentication.pub" = mkPubKeyLink "${sshPubKeysPath}/github/authentication.pub";
    ".ssh/github/signing.pub" = mkPubKeyLink "${sshPubKeysPath}/github/signing.pub";
  };

  sops.secrets = {
    "ssh/github/authentication" = {
      sopsFile = "${sshSecretsPath}/github.yaml";
      key = "authentication";
      mode = "0600";
    };

    "ssh/github/signing" = {
      sopsFile = "${sshSecretsPath}/github.yaml";
      key = "signing";
      mode = "0600";
    };
  };

  programs.ssh.matchBlocks."github.com" = {
    hostname = "github.com";
    identityFile = config.sops.secrets."ssh/github/authentication".path;
  };

  programs.git = {
    enable = true;

    lfs = {
      enable = true;
    };

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

        signingKey = config.sops.secrets."ssh/github/signing".path;
      };
    };
  };
}
