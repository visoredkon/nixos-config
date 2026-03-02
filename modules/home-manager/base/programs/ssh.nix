{
  config,
  lib,
  sshLib,
  ...
}:
let
  inherit (sshLib) sshSecretsPath sshPubKeysPath mkPubKeyLink;

  sopsHostsFile = "${sshSecretsPath}/hosts.yaml";

  hostNames = [
    "aura"
    "genesis"
    "siti"
  ];

  mkHostSecrets =
    name:
    map
      (
        field:
        lib.nameValuePair "ssh/hosts/${name}/${field}" {
          sopsFile = sopsHostsFile;
          key = "${name}/${field}";
          mode = if field == "private_key" then "0600" else "0400";
        }
      )
      [
        "user"
        "hostname"
        "port"
        "private_key"
      ];

  secretPlaceholder = name: field: config.sops.placeholder."ssh/hosts/${name}/${field}";

  mkHostConfig = name: ''
    Host ${name}
      HostName ${secretPlaceholder name "hostname"}
      User ${secretPlaceholder name "user"}
      Port ${secretPlaceholder name "port"}
      IdentityFile ${config.sops.secrets."ssh/hosts/${name}/private_key".path}
  '';
in
{
  home.file = lib.listToAttrs (
    map (
      name: lib.nameValuePair ".ssh/vps/${name}.pub" (mkPubKeyLink "${sshPubKeysPath}/vps/${name}.pub")
    ) hostNames
  );

  sops.secrets = lib.listToAttrs (lib.concatMap mkHostSecrets hostNames);

  sops.templates."ssh-hosts".content = lib.concatMapStringsSep "\n" mkHostConfig hostNames;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ config.sops.templates."ssh-hosts".path ];

    matchBlocks."*" = {
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
  };
}
