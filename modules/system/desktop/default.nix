{ self, ... }: {
  flake.nixosModules.desktop = { pkgs, ... }: {
    imports = with self.nixosModules; [
      core
      audio
      network
      fonts
      theme
      hyprland
      hyprpaper
      hypridle
      hyprlock
      session
    ];

    environment.systemPackages = with pkgs; [
      mpv
      imv
      pavucontrol
      networkmanagerapplet
      xdg-desktop-portal-gtk
    ];
  };
}
