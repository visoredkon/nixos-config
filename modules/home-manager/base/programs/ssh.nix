{
  config,
  hostname,
  lib,
  pkgs,
  sshLib,
  ...
}:
let
  inherit (sshLib) mkPubKeyLink sshPubKeysPath sshSecretsPath;

  hostNames = [
    "aura"
    "genesis"
    "siti"
  ];

  sopsHostsFile = "${sshSecretsPath}/hosts.yaml";

  mkHostConfig = name: ''
    Host ${name}
      HostName ${secretPlaceholder name "hostname"}
      User ${secretPlaceholder name "user"}
      Port ${secretPlaceholder name "port"}
      IdentityFile ${config.sops.secrets."ssh/hosts/${name}/private_key".path}
      IdentitiesOnly yes
  '';

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
in
{
  home = {
    file = lib.listToAttrs (
      map (
        name: lib.nameValuePair ".ssh/vps/${name}.pub" (mkPubKeyLink "${sshPubKeysPath}/vps/${name}.pub")
      ) hostNames
    );

    sessionVariables = lib.mkIf (hostname == "nixu") {
      SSH_ASKPASS = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
    };
  };

  sops.secrets = lib.listToAttrs (lib.concatMap mkHostSecrets hostNames);

  sops.templates."ssh-hosts".content = lib.concatMapStringsSep "\n" mkHostConfig hostNames;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ config.sops.templates."ssh-hosts".path ];

    settings."*" = {
      addKeysToAgent = "yes";
      compression = false;
      controlMaster = "auto";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "10m";
      forwardAgent = false;
      hashKnownHosts = true;
      serverAliveCountMax = 3;
      serverAliveInterval = 0;
      userKnownHostsFile = "~/.ssh/known_hosts";
    };
  };
}
