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
    (symlinkJoin {
      name = "inkscape-textext-fixed";
      paths = [
        (inkscape-with-extensions.override {
          inkscapeExtensions = [inkscape-extensions.textext];
        })
      ];
      nativeBuildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/inkscape \
          --prefix PYTHONPATH : "${python3.withPackages (ps: with ps; [pygobject3])}/${python3.sitePackages}"
      '';
    })
	kdePackages.kdenlive
    kicad
    libreoffice-qt6
    mpv
    networkmanagerapplet
    networkmanager
    kdePackages.plasma-nm
    obs-studio
    octaveFull
    openscad
    pavucontrol
    prismlauncher
    qutebrowser
    showmethekey
    telegram-desktop
    unstable.signal-desktop
    vesktop
    wineWow64Packages.stable
    zapzap

    # --- WM stuff ---
    libnotify
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
}
