{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Packages in each category are sorted alphabetically

    # Desktop apps
    # anki
    arduino-cli
    blender
    brave
    docker
    freecad-wayland
    gimp3
    imv
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

    # CLI utils
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

    # Coding stuff
    # neovim
    gcc
    gdb
    python314

    # WM stuff
    libsForQt5.xwaylandvideobridge
    libnotify
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland

    # Other
    bemoji
    nix-prefetch-scripts
  ];
}
