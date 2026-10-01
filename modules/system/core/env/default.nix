{ ... }: {
  flake.nixosModules.env = { ... }: {
    environment.sessionVariables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };
    fonts.fontDir.enable = true;
  };
}
