{config, ...}: {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    initContent = ''
      # Ctrl+delete
      bindkey '^H' backward-delete-word

      # This is needed so that trashy
      # doesnt shit itself and die when I press Tab
      customtrash() { command trash put "$@" }

      # Imports scripts directory
      export PATH="$HOME/.config/zsh/scripts:$PATH"
    '';
  };
}
