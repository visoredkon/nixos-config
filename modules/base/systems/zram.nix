{ ... }:

{
  services.zram-generator = {
    enable = true;
    settings = {
      zram0 = {
        compression-algorithm = "zstd";

        zram-size = "ram * 1.5";

        priority = 100;
      };
    };
  };
}
