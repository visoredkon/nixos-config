{ ... }:

{
  security = {
    rtkit = {
      enable = true;
    };

    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };

    # tpm2 = {
    # enable = true;
    # abrmd = {
    #   enable = true;
    # };
    #
    # pkcs11 = {
    #   enable = true;
    # };
    # };
  };
}
