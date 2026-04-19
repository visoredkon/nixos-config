{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    hyprshutdown
  ];

  programs.hyprland = {
    enable = true;

    withUWSM = true;
    xwayland.enable = true;
  };
}
