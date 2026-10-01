{
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.rmpc = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.rmpc ];
  });
  perSystem = { pkgs, ... }: let
    wrap = import ../../_lib/wrap.nix { inherit pkgs; lib = pkgs.lib; };
    conf = pkgs.runCommandLocal "rmpc-config" { } ''
      mkdir -p $out
      cp ${./config.ron} $out/config.ron
      cp ${./theme.ron} $out/theme.ron
    '';
  in {
    packages.rmpc = wrap {
      package = pkgs.rmpc;
      bin = "rmpc";
      flags = [ "--config" "${conf}/config.ron" ];
    };
  };
}
