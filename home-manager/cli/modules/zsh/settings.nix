{config, ...}: {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    sessionVariables = {
      STUDY_DIR = "$HOME/study";
    };

    initContent = ''
               # Ctrl+delete
               bindkey '^H' backward-delete-word

               # This is needed so that trashy
               # doesnt shit itself and die when I press Tab
               customtrash() { command trash put "$@" }

         # Make sure the path array only contains unique directories
             typeset -U path

             # Add your custom scripts directory cleanly
             path+=("$CONFIG_DIRECTORY/home-manager/cli/modules/zsh/scripts")
             export PATH

       # Boot Hyprland
       if uwsm check may-start > /dev/null && uwsm select; then
      exec systemd-cat -t uwsm_start uwsm start default
       fi
    '';
  };
}
