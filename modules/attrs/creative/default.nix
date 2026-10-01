{ self, moduleWithSystem, ... }: {
  flake.nixosModules.creative = moduleWithSystem ({ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      blender
      freecad
      gimp
      kdePackages.kdenlive
      kicad
      libreoffice-qt6
      openscad
      octaveFull
      arduino-cli
      inkscape-with-extensions
    ];
  });
}
