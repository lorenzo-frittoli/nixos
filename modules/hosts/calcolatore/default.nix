{ self, inputs, ... }: {
  flake.nixosConfigurations.calcolatore = inputs.nixpkgs.lib.nixosSystem {
    modules = [ inputs.disko.nixosModules.disko ] ++ (with self.nixosModules; [
      desktop
      nvidiaDrivers
      development
      creative
      gaming
      multimedia
      comms
      desktopApps
      calcolatoreConfiguration
    ]);
  };

  flake.diskoConfigurations.calcolatore = import ./_disko.nix;
}
