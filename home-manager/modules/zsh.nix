{ config, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      os-test = "nh os test && exec zsh";
      os-switch = "nh os switch && exec zsh";
      os-update = "nh os switch --update && exec zsh";
      os-clean = "nh clean all --keep 3";

      hm-test = "nh home test && exec zsh";
      hm-switch = "nh home switch && exec zsh";
      hm-update = "nh home switch --update && exec zsh";
      hm-clean = "nh clean user --keep 3";

      full-update = "os-update && hm-update";
      full-clean = "os-clean && hm-clean";

      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";

      cd = "z";
      yz = "yazi";
      xo = "xdg-open";
      microfetch = "microfetch && echo";

      rm = "echo 'use trash instead'";
      tsp = "customtrash";
      tsl = "trash list";
      tsr = "trash list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trash restore --match=exact --force";

      hotspot = ''
        # Get eth and wifi interface from nmcli
        ETHERNET=$(nmcli dev | sed '/ethernet/!d' | fzf -e | awk '{print $1;}')
        WIFI=$(nmcli dev | sed '/wifi/!d' | fzf -e | awk '{print $1;}')

        # Input name and password
        vared -p 'Hotspot name: ' -c NAME
        vared -p 'Hotspot password: ' -c PASSWORD

        # Run command
        sudo create_ap $WIFI $ETHERNET $NAME $PASSWORD
      '';
    };

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    initContent = ''
      # Start UWSM
      if uwsm check may-start > /dev/null && uwsm select; then
        exec systemd-cat -t uwsm_start uwsm start default
      fi

      # This is needed so that trashy
      # doesnt shit itself and die when I press Tab
      customtrash() { command trash put "$@" }
    '';
  };
}
