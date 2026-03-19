{ ... }:

{
  services.zram-generator = {
    enable = true;
    settings = {
      zram0 = {
        compression-algorithm = "zstd";
        zram-size = "ram / 2";
        priority = 100;
      };
    };
  };
}
