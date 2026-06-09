{config, ...}: {
  programs.zsh = {
    shellAliases = {
      os-build = "nh os build && exec zsh";
      os-test = "nh os test && exec zsh";
      os-switch = "nh os switch && exec zsh";
      os-update = "nh os switch --update && exec zsh";
      os-clean = "nh clean all --keep 3";

      hm-build = "nh home build && exec zsh";
      hm-switch = "nh home switch && exec zsh";
      hm-update = "nh home switch --update && exec zsh";
      hm-clean = "nh clean user --keep 3";

      full-update = "os-update && hm-update";
      full-clean = "os-clean && hm-clean";

      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";

      fd = "z";
      fdi = "zi";
      yz = "yazi";
      xo = "xdg-open";
      microfetch = "microfetch && echo";

      rm = "echo 'use trash instead'";
      tsp = "customtrash";
      tsl = "trash list";
      tsr = "trash list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trash restore --match=exact --force";
    };
  };
}
