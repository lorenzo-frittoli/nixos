{ ... }: {
  flake.nixosModules.eza = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.eza ];
  };
}
