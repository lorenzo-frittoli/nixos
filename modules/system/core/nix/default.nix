{ ... }: {
  flake.nixosModules.nix = { pkgs, ... }: {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "frittata" ];
    };
    nix.package = pkgs.lixPackageSets.stable.lix;
    nixpkgs.overlays = [
      (final: prev: {
        inherit
          (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })
    ];
  };
}
