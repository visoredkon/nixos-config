{
  config,
  inputs,
  username,
  ...
}:

{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  _module.args.secretsPath = inputs.secrets;

  sops = {
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
