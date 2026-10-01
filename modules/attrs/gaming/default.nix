{ self, moduleWithSystem, ... }: {
  flake.nixosModules.gaming = moduleWithSystem ({ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      prismlauncher
      wineWow64Packages.stable
      vesktop
      zapzap
    ];
  });
}
