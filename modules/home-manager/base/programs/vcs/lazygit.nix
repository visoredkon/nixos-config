{
  pkgs,
  ...
}:

{
  programs.lazygit = {
    enable = true;
    settings.git.pagers = [
      {
        pager = "${pkgs.delta}/bin/delta --dark --paging=never";
      }
    ];
  };
}
