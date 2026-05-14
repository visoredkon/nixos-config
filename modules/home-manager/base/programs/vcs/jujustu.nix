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
          name = gitUser.name;
          email = gitUser.email;
        };
      };
    };

    jjui = {
      enable = configPrograms.jujutsu.enable;
    };
  };
}
