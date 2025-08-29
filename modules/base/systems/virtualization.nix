{ username, ... }:

{
  boot = {
    extraModprobeConfig = ''
      options kvm_intel nested=1
    '';
    kernelModules = [ "kvm-intel" ];
  };

  users.users.${username} = {
    extraGroups = [
      "kvm"
    ];
  };
}
