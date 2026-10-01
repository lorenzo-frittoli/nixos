{ self, moduleWithSystem, ... }: {
  flake.nixosModules.desktopApps = moduleWithSystem ({ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      anki
      brave
      qutebrowser
      showmethekey
      super-productivity
      kdePackages.okular
      kdePackages.plasma-nm
      networkmanager
      git-graph
      microfetch
      steam-run-free
      nix-prefetch-scripts
      mediainfo
      ffmpegthumbnailer
      libreoffice-qt6
    ];
  });
}
