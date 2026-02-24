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

  sops.secrets."wg0-private-key" = {
    sopsFile = "${secretsPath}/${hostname}/wireguard/wg0.yaml";
    key = "private_key";
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.172.192.2/32" ];
      listenPort = 51820;

      # `privateKey` menerima string value, meskipun bisa baca dari sops,
      # nilainya tetap masuk Nix store (plaintext), jadi ga aman:
      # privateKey = builtins.readFile config.sops.secrets."wg0-private-key".path;
      #
      # `privateKeyFile` membaca langsung dari file saat runtime,
      # value ga masuk Nix store:
      privateKeyFile = config.sops.secrets."wg0-private-key".path;

      dns = [
        "1.1.1.1"
        "1.0.0.1"
      ];

      peers = [
        {
          publicKey = "wYurqHbnOxGO0UkwhSV1GtsK+75POFv1zdX2lGbH/z4=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "27.112.78.81:53119";
          persistentKeepalive = 25;
        }
      ];
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
