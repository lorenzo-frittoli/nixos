{lib, ...}: {
  options.theme = {
    gaps = lib.mkOption {
      type = lib.types.int;
      default = 5;
    };

    rounding = lib.mkOption {
      type = lib.types.int;
      default = 5;
    };

    border_size = lib.mkOption {
      type = lib.types.int;
      default = 2;
    };
  };
}
