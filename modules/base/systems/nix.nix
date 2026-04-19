{
  config,
  hostname,
  secretsPath,
  ...
}:

{
  sops = {
    secrets."github-token" = {
      sopsFile = "${secretsPath}/${hostname}/github-token.yaml";
      key = "github_token";
    };

    templates."nix-access-token.conf" = {
      content = ''
        access-tokens = github.com=${config.sops.placeholder."github-token"}
      '';
    };
  };

  nix = {
    extraOptions = ''
      !include ${config.sops.templates."nix-access-token.conf".path}
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      cores = 12;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = "auto";
      trusted-users = [
        "@wheel"
      ];
    };
  };
}
