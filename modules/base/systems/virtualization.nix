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
      dnsmasq
      qemu_kvm

      terraform
    ];
  };

  networking = lib.mkIf (builtins.pathExists "/sys/class/net/enp0s20f0u4u4c2") {
    bridges.br0.interfaces = [
      "enp0s20f0u4u4c2"
    ];

    interfaces.br0.useDHCP = true;
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

  # virtualisation.qemu = {
  #   package = pkgs.qemu_kvm;
  #   guestAgent.enable = true;
  #   diskInterface = "virtio";
  #   options = [
  #     # Acceleration & machine model
  #     "-enable-kvm"
  #     "-machine"
  #     "q35,accel=kvm,kernel_irqchip=on"
  #     "-global"
  #     "kvm-pit.lost_tick_policy=discard"
  #
  #     # CPU & topology
  #     "-cpu"
  #     "host,+hypervisor,+invtsc"
  #     "-smp"
  #     "sockets=1,cores=8,threads=1"
  #
  #     # Memory
  #     "-m"
  #     "12G"
  #     "-overcommit"
  #     "mem-lock=off"
  #
  #     # Storage
  #     "-object"
  #     "iothread,id=iothread0"
  #     "-device"
  #     "virtio-scsi-pci,id=scsi0,iothread=iothread0,num_queues=8"
  #
  #     "-drive"
  #     "file=/absolute/path/nixos.raw,format=raw,if=none,id=drive0,cache=none,aio=native,discard=unmap,detect-zeroes=unmap"
  #     "-device"
  #     "scsi-hd,bus=scsi0.0,drive=drive0,write-cache=on"
  #
  #     # Networking (bridge)
  #     "-netdev"
  #     "bridge,br=br0,helper=/run/wrappers/bin/qemu-bridge-helper,id=net0"
  #     "-device"
  #     "virtio-net-pci,mq=on,netdev=net0,vectors=18"
  #
  #     # Display
  #     "-display"
  #     "gtk"
  #     "-vga"
  #     "virtio"
  #   ];
  # };
}
