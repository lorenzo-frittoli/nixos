{
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.wofi = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.wofi ];
  });
  perSystem = { pkgs, ... }: let
    wrap = import ../../_lib/wrap.nix { inherit pkgs; lib = pkgs.lib; };
  in {
    packages.wofi = wrap {
      package = pkgs.wofi;
      bin = "wofi";
      flags = [
        "--conf"
        (toString ./config)
        "--style"
        (toString ./style.css)
      ];
    };
  };
}
