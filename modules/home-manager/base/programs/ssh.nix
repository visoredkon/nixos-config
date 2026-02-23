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

  mkVpsKey =
    name:
    mkSshKey {
      sopsFile = "${sshSecrets}/vps.yaml";
      key = name;
      path = "${sshDir}/vps/${name}";
    };
in
{
  home.file = {
    ".ssh/github.pub" = mkPubKeyLink "${sshPubKeys}/github.pub";
  }
  // lib.mapAttrs' (
    name: _: lib.nameValuePair ".ssh/vps/${name}.pub" (mkPubKeyLink "${sshPubKeys}/vps/${name}.pub")
  ) (lib.genAttrs [ "aura" "genesis" "siti" ] lib.id);

  sops.secrets = {
    "ssh/github" = mkSshKey {
      sopsFile = "${sshSecrets}/github.yaml";
      key = "private_key";
      path = "${sshDir}/github";
    };

    "ssh/config.d/secret_hosts" = mkSshKey {
      sopsFile = "${sshSecrets}/config.d/secret_hosts.yaml";
      key = "secret_host";
      path = "${sshDir}/config.d/secret_hosts";
    };
  }
  // lib.mapAttrs' (name: value: lib.nameValuePair "ssh/vps/${name}" value) (
    lib.genAttrs [ "aura" "genesis" "siti" ] mkVpsKey
  );

  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    includes = [ "config.d/*" ];

    matchBlocks = {
      "*" = {
        addKeysToAgent = "no";
        compression = false;
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
        forwardAgent = false;
        hashKnownHosts = true;
        serverAliveCountMax = 3;
        serverAliveInterval = 0;
        userKnownHostsFile = "~/.ssh/known_hosts";
      };

      "github.com" = {
        hostname = "github.com";
        identityFile = config.sops.secrets."ssh/github".path;
      };
    };
  };
}
