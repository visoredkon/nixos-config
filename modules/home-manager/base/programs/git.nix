{
  config,
  hostname,
  lib,
  secretsPath,
  ...
}:

let
  sshDir = "${config.home.homeDirectory}/.ssh";
  sshSecrets = "${secretsPath}/${hostname}/ssh";
  sshPubKeys = "${sshSecrets}/public-keys";

  mkPubKeyLink = src: {
    source = src;
    executable = false;
  };

  mkSshKey =
    {
      sopsFile,
      key,
      path ? null,
    }:
    {
      inherit key sopsFile;
      mode = "0600";
    }
    // lib.optionalAttrs (path != null) { inherit path; };
in
{
  home.file = {
    ".ssh/github/authentication.pub" = mkPubKeyLink "${sshPubKeys}/github/authentication.pub";
    ".ssh/github/signing.pub" = mkPubKeyLink "${sshPubKeys}/github/signing.pub";
  };

  sops.secrets = {
    "ssh/github/authentication" = mkSshKey {
      sopsFile = "${sshSecrets}/github.yaml";
      key = "authentication";
      path = "${sshDir}/github/authentication";
    };

    "ssh/github/signing" = mkSshKey {
      sopsFile = "${sshSecrets}/github.yaml";
      key = "signing";
      path = "${sshDir}/github/signing";
    };
  };

  programs.ssh.matchBlocks."github.com" = {
    hostname = "github.com";
    identityFile = config.sops.secrets."ssh/github/authentication".path;
  };

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

        signingKey = config.sops.secrets."ssh/github/signing".path;
      };
    };
  };
}
