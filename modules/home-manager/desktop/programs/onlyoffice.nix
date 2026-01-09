{ ... }:

{
  programs.onlyoffice = {
    enable = true;

    settings = {
      editorWindowMode = false;
      forcedRtl = false;
    };
  };
}
