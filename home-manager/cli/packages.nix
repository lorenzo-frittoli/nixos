{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    # --- CLI utils ---
    p7zip
    btop
    cava
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
    rmpc
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
    gemini-cli
    (python3.withPackages (ps: with ps; [pygobject3 tkinter]))
    rust-analyzer
    rustc
    typst
    typstyle
    vale

    # --- Other ---
    nix-prefetch-scripts
  ];
}
