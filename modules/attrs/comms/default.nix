{ self, moduleWithSystem, ... }: {
  flake.nixosModules.comms = moduleWithSystem ({ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      telegram-desktop
      pkgs.unstable.signal-desktop
    ];
  });
}
