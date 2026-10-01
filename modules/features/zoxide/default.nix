{ ... }: {
  flake.nixosModules.zoxide = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.zoxide ];
  };
}
