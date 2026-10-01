{ ... }: {
  flake.nixosModules.fonts = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
      roboto
      source-sans
      font-awesome
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      inter
      corefonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      nerd-fonts.symbols-only
    ];
  };
}
