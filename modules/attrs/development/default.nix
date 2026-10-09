{ self, moduleWithSystem, ... }: {
  flake.nixosModules.development = moduleWithSystem ({ pkgs, ... }: {
    imports = with self.nixosModules; [
      git
      neovim
      zsh
      nh
      pi
    ];
    environment.systemPackages = with pkgs; [
      cargo
      rustc
      rust-analyzer
      gcc
      gdb
      cppcheck
      gh
      sops
      ssh-to-age
      fzf
      ripgrep
      typst
      typstyle
      tinymist
      websocat
      vale
      (python3.withPackages (ps: with ps; [ pygobject3 tkinter ]))
    ];
  });
}
