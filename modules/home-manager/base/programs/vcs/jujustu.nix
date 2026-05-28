{
  config,
  lib,
  pkgs,
  ...
}:
let
  configPrograms = config.programs;
  gitUser = configPrograms.git.settings.user;
in
{
  programs = {
    jujutsu = {
      enable = true;

      settings = {
        user = {
          inherit (gitUser) name email;
        };

        ui = {
          diff-formatter = ":git";
          pager = "${lib.getExe pkgs.delta}";
        };
      };
    };

    jjui = {
      enable = configPrograms.jujutsu.enable;
    };
  };
}
