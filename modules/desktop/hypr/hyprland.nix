_:

{
  programs = {
    uwsm.enable = true;

    hyprland = {
      enable = true;

      withUWSM = true;
      xwayland.enable = true;
    };
  };
}
