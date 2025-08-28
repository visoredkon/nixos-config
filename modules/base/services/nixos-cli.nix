{
  inputs,
  pkgs,
  username,
  ...
}:

{
  imports = [ inputs.nixos-cli.nixosModules.nixos-cli ];

  environment.systemPackages = with pkgs; [
    nvd
    nix-output-monitor
  ];

  services.nixos-cli = {
    enable = true;
    config = {
      config_location = "/home/${username}/.config/nixos-config";
      use_nvd = true;

      aliases = {
        boot = [
          "apply"
          "--no-activate"
        ];
        build = [
          "apply"
          "--no-boot"
          "--no-activate"
          "--output"
          "./result"
        ];
        genlist = [
          "generation"
          "list"
        ];
        rollback = [
          "generation"
          "rollback"
        ];
        switch = [
          "generation"
          "switch"
        ];
        test = [
          "apply"
          "--no-boot"
          "--yes"
        ];
        testcfg = [
          "apply"
          "--no-boot"
          "--no-activate"
          "--yes"
        ];
      };
      apply = {
        use_nom = true;
      };
    };
  };
}
