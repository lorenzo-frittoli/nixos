{ self, inputs, ... }: {
  flake.nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
    modules = [ inputs.disko.nixosModules.disko ] ++ (with self.nixosModules; [
      core
      network
      serverConfiguration
    ]);
  };

  flake.diskoConfigurations.server = import ./_disko.nix;
}
