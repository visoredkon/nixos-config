{ pkgs, username, ... }:

{
  programs = {
    wireshark = {
      enable = true;
      package = pkgs.wireshark;

      dumpcap = {
        enable = true;
      };
    };
  };

  users.users.${username} = {
    extraGroups = [
      "wireshark"
    ];
  };
}
