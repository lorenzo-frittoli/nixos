{ self, moduleWithSystem, ... }: {
  flake.nixosModules.development = moduleWithSystem ({ pkgs, ... }: {
    imports = with self.nixosModules; [
      git
      neovim
      zsh
      nh
    ];
    environment.systemPackages = with pkgs; [
      cargo
      rustc
      rust-analyzer
      gcc
      gdb
      cppcheck
      gh
      fzf
      ripgrep
      gemini-cli
      pi-coding-agent
      typst
      typstyle
      vale
      (python3.withPackages (ps: with ps; [ pygobject3 tkinter ]))
    ];
  });
}
