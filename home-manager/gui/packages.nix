{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    # --- Desktop apps ---
    anki
    arduino-cli
    bemoji
    blender
    brave
    brightnessctl
    freecad
    gimp
    grimblast
    hyprpicker
    imv
    inkscape-with-extensions
    kicad
    libreoffice-qt6
    mpv
    networkmanagerapplet
    networkmanager
    kdePackages.plasma-nm
    octaveFull
    openscad
    pavucontrol
    prismlauncher
    qutebrowser
    showmethekey
    telegram-desktop
    unstable.signal-desktop
    vesktop
    zapzap

    # --- WM stuff ---
    libnotify
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
}
