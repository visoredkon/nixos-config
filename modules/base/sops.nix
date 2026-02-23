{
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  _module.args.secretsPath = inputs.secrets;

  sops = {
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };

  environment.systemPackages = with pkgs; [
    age
    ssh-to-age

    sops
  ];
}
