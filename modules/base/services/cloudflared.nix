{
  config,
  hostname,
  pkgs,
  secretsPath,
  ...
}:

{
  sops = {
    secrets."cloudflared-cert" = {
      key = "cert";
      sopsFile = "${secretsPath}/${hostname}/cloudflare/cloudflared.yaml";
    };
    secrets."cloudflared-creds" = {
      key = "creds";
      sopsFile = "${secretsPath}/${hostname}/cloudflare/cloudflared.yaml";
    };
  };

  systemd.services."cloudflared-tunnel-prism".serviceConfig.Environment = [
    "TUNNEL_POST_QUANTUM=true"
    "TUNNEL_PROTOCOL=http2"
  ];

  networking.firewall.allowedUDPPorts = [ 7844 ];

  environment.systemPackages = with pkgs; [ cloudflared ];

  services.cloudflared = {
    enable = true;
    certificateFile = config.sops.secrets."cloudflared-cert".path;

    tunnels = {
      prism = {
        credentialsFile = config.sops.secrets."cloudflared-creds".path;
        default = "http_status:404";

        ingress = {
          "prism.pahril.web.id" = {
            originRequest.noTLSVerify = true;
            service = "https://10.99.99.5:8006";
          };
        };
      };
    };
  };
}
