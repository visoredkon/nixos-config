{ ... }:

{
  services = {
    cliphist = {
      enable = true;
    };
    tldr-update = {
      enable = true;
      period = "daily";
    };
  };
}
