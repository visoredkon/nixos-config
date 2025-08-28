{ username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "Pahril";
  };
}
