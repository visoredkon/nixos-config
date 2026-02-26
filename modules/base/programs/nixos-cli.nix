{
  inputs,
  pkgs,
  username,
  ...
}:

{
  imports = [ inputs.nixos-cli.nixosModules.nixos-cli ];

  environment.systemPackages = with pkgs; [
    # nvd
    nix-output-monitor
  ];

  programs.nixos-cli = {
    enable = true;
    settings = {
      config_location = "/home/${username}/.config/nixos-config";
      use_nvd = false;

      option = {
        prettify = true;
      };

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
          "--local-root"
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
