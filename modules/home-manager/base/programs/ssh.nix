{ config, ... }:

{
  programs.ssh = {
    enable = true;

    # extraConfig = ''
    #   Host github.com
    #     User git
    #     Hostname github.com
    #     IdentityFile ${config.home.homeDirectory}/.ssh/github
    # '';
  };
}
