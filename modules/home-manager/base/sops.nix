{
  config,
  hostname,
  inputs,
  secretsPath,
  ...
}:

{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets."github-token" = {
      sopsFile = "${secretsPath}/${hostname}/github-token.yaml";
      key = "github_token";
      mode = "0600";
    };

    templates."nix-access-tokens.conf" = {
      path = "${config.home.homeDirectory}/.config/nix/access-tokens.conf";
      content = ''
        access-tokens = github.com=${config.sops.placeholder."github-token"}
      '';
      mode = "0600";
    };
  };
}
