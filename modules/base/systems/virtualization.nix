{
  config,
  lib,
  pkgs,
  username,
  ...
}:

{
  boot = {
    extraModprobeConfig = ''
      options kvm_intel nested=1
    '';
    kernelModules = [ "kvm-intel" ];
  };

  environment = {
    etc."qemu/bridge.conf" = lib.mkIf (!config.virtualisation.libvirtd.enable) {
      text = "allow br0";
    };

    systemPackages = with pkgs; [
      qemu_kvm
    ];
  };

  networking.networkmanager.ensureProfiles.profiles = {
    br0 = {
      connection = {
        id = "br0";
        type = "bridge";
        interface-name = "br0";
        autoconnect = false;
      };

      ipv4.method = "auto";
      ipv6.method = "auto";
    };
  };

  security.wrappers.qemu-bridge-helper = lib.mkIf (!config.virtualisation.libvirtd.enable) {
    owner = "root";
    group = "root";
    source = "${pkgs.qemu_kvm}/libexec/qemu-bridge-helper";
    capabilities = "cap_net_admin+ep";
  };

  users = {
    users.${username} = {
      extraGroups = [
        "kvm"
      ];
    };
  };
}
