{ ... }: {
  flake.nixosModules.nh = { ... }: {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep 3";
      flake = "/home/frittata/nixos";
    };
  };
}
