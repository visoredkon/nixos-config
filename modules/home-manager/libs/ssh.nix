{
  hostname,
  secretsPath,
  ...
}:
let
  sshSecretsPath = "${secretsPath}/${hostname}/ssh";
in
{
  _module.args.sshLib = {
    inherit sshSecretsPath;
    sshPubKeysPath = "${sshSecretsPath}/public-keys";

    mkPubKeyLink = src: {
      source = src;
      executable = false;
    };
  };
}
