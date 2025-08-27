{ username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "Pahril";
    extraGroups = [
      "networkmanager"
      "wheel"
      "seat"
    ];
  };
}
