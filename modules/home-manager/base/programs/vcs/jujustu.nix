{
  config,
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
      };
    };

    jjui = {
      enable = configPrograms.jujutsu.enable;
    };
  };
}
