{ username, ... }:

{
  security = {
    rtkit = {
      enable = true;
    };

    sudo = {
      enable = false;
      execWheelOnly = true;
    };

    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };

  users.users.${username} = {
    extraGroups = [
      "wheel"
    ];
  };
}
