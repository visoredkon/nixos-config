{
  config,
  username,
  stateVersion,
  ...
}:

{
  imports = [
    ../libs/ssh.nix

    ./packages.nix
    ./programs

    ./services

    ./themes/catppuccin.nix

    ./sops.nix
  ];

  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";

    sessionVariables = {
      NIXOS_CONFIG = "${config.home.homeDirectory}/.config/nixos-config";
    };

    shell.enableFishIntegration = true;
  };
}
