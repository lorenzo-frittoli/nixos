{
  environment.sessionVariables = rec {
    TERMINAL = "kitty";
    EDITOR = "nvim";
    XDG_BIN_HOME = "$HOME/.local/bin";
    CONFIG_DIRECTORY = "$HOME/nixos";
    # PATH = [
    #   "${XDG_BIN_HOME}"
    # ];
  };
}
