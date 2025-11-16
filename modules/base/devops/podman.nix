{ pkgs, ... }:

{
  virtualisation = {
    containers = {
      enable = true;
    };

    podman = {
      enable = true;

      defaultNetwork.settings = {
        dns_enabled = true;
      };

      dockerCompat = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    podman-desktop
  ];
}
