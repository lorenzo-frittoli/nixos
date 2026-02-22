{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    # --- CLI utils ---
    p7zip
    btop
    cliphist
    ffmpeg
    ffmpegthumbnailer
    figlet
    fzf
    gh
    git-graph
    linux-wifi-hotspot
    mediainfo
    microfetch
    ntfs3g
    playerctl
    ripgrep
    silicon
    steam-run-free
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
    python3
    rust-analyzer
    rustc
    typst
    typstyle
    vale

    # --- Other ---
    nix-prefetch-scripts
  ];
}
