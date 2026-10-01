{ ... }: {
  flake.nixosModules.network = { ... }: {
    networking.networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
}
