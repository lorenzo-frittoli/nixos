{pkgs, ...}: {
  # Fonts
  fonts.packages = with pkgs; [
    # --- Core Fonts ---
    jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    font-awesome

    # --- Other Fonts ---
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    inter
    liberation_ttf

    # --- Chinese ---
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif

    # --- Symbols ---
    nerd-fonts.symbols-only
  ];

  # Packages required by all systems
  environment.systemPackages = with pkgs; [
    git
    wget
  ];
}
