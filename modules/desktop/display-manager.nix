{
  pkgs,
  username,
  ...
}:

{
  services = {
    # nixpkgs rev 64c08a7 broke seatd.
    #
    # The seatd systemd service swapped its wrapper from sdnotify-wrapper
    # to s6-notify-socket-from-fd. seatd signals readiness by writing to
    # a file descriptor (-n 1). sdnotify-wrapper reads that fd and tells
    # systemd. s6-notify-socket-from-fd expects sd_notify() via
    # NOTIFY_SOCKET - seatd doesn't do that.
    #
    # Systemd never gets READY=1 -> timeout -> restart loop. Login hangs.
    #
    # 173: sdnotify-wrapper -> active (running), NRestarts == 0
    # 175: s6-notify-socket-from-fd -> stuck "activating", NRestarts > 0
    #
    # Ref: seatd(1) "-n <fd>  FD to notify readiness on"
    seatd = {
      enable = false;
      user = "${username}";
    };

    displayManager = {
      sddm = {
        enable = true;
        package = pkgs.qt6Packages.sddm;

        wayland = {
          enable = true;
        };
      };
    };
  };

  # users.users.${username} = {
  #   extraGroups = [
  #     "seat"
  #   ];
  # };
}
