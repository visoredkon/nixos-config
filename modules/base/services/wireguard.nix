{
  config,
  hostname,
  pkgs,
  secretsPath,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  sops.secrets = {
    "wg0-private-key" = {
      sopsFile = "${secretsPath}/${hostname}/wireguard/wg0.yaml";
      key = "private_key";
    };
    "wg0-endpoint" = {
      sopsFile = "${secretsPath}/${hostname}/wireguard/wg0.yaml";
      key = "endpoint";
    };
  };

  sops.templates."wg0.conf" = {
    content = ''
      [Interface]
      PrivateKey = ${config.sops.placeholder."wg0-private-key"}
      Address = 10.172.192.2/32
      ListenPort = 51820
      DNS = 1.1.1.1, 1.0.0.1

      [Peer]
      PublicKey = wYurqHbnOxGO0UkwhSV1GtsK+75POFv1zdX2lGbH/z4=
      AllowedIPs = 0.0.0.0/0
      Endpoint = ${config.sops.placeholder."wg0-endpoint"}
      PersistentKeepalive = 25
    '';
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      configFile = config.sops.templates."wg0.conf".path;
    };
  };

  networking.firewall = {
    allowedUDPPortRanges = [
      {
        from = 30000;
        to = 60000;
      }
    ];
  };
}
