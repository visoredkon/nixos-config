{
  pkgs-unstable,
  ...
}:

{
  programs.mise = {
    enable = true;
    package = pkgs-unstable.mise;

    globalConfig.settings = {
      jobs = 12;
    };
  };
}
