{
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.hyprlock = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.hyprlock ];
  });
  perSystem = { pkgs, ... }: let
    wrap = import ../../_lib/wrap.nix { inherit pkgs; lib = pkgs.lib; };
  in {
    packages.hyprlock = wrap {
      package = pkgs.hyprlock;
      bin = "hyprlock";
      flags = [ "--config" (toString ./hyprlock.conf) ];
    };
  };
}
