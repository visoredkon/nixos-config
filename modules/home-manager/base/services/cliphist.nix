{ ... }:

{
  services.cliphist = {
    enable = true;
    extraOptions = [
      "-max-items"
      "18446744073709551615"
    ];
  };
}
