# TEMPLATE (underscore-prefixed, so import-tree skips it).
# Copy this file to modules/features/<name>/default.nix and replace `name`.
# Exposes:
#   - flake.nixosModules.<name>  : installs the wrapped binary system-wide
#   - packages.<name>            : the wrapped binary, runnable via `nix run .#<name>`
{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.name = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.name ];
  });
  perSystem = { pkgs, ... }: {
    packages.name = inputs.wrappers.wrappers.name.wrap {
      inherit pkgs;
    };
  };
}
