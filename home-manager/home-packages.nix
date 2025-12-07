{ pkgs, pkgs-unstable, ... }:
{
  # Allow unfree packages (e.g. obsidian, steam-run, spotify)
  nixpkgs.config.allowUnfree = true;

  # Combine the lists
  home.packages = with pkgs; [
    # --- Desktop apps ---
    anki
    arduino-cli
    blender
    brave
    docker # Note: This only installs the CLI. You need virtualisation.docker.enable = true in system config for the daemon.
    freecad # "freecad-wayland" is usually not a separate package
    gimp # "gimp3" is not a standard attribute name yet
    imv
    itch
    kicad
    libreoffice-qt6
    mpv
    obsidian
    openscad
    pavucontrol
    signal-desktop
    telegram-desktop
    vesktop
    whatsie

    # --- CLI utils ---
    btop
    brightnessctl
    cliphist
    ffmpeg
    ffmpegthumbnailer
    figlet
    fzf
    gh
    git-graph
    grimblast
    htop
    hyprpicker
    linux-wifi-hotspot
    mediainfo
    microfetch
    ntfs3g
    playerctl
    ripgrep
    showmethekey
    silicon
    steam-run
    trashy
    udisks
    ueberzugpp
    unzip
    w3m
    wget
    wl-clipboard
    wtype
    yazi
    yt-dlp
    zip
    zoxide

    # --- Coding stuff ---
    cargo
    gcc
    gdb
    python3 # changed from python314 (doesn't exist/too new)
    rust-analyzer
    rustc

    # --- WM stuff ---
    libsForQt5.xwaylandvideobridge
    libnotify
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland

    # --- Other ---
    bemoji
    nix-prefetch-scripts
  ];
}
