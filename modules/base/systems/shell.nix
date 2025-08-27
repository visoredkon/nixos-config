{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    generateCompletions = true;

    useBabelfish = true;
  };

  users.defaultUserShell = pkgs.fish;
}
