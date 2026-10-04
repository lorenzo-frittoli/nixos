{ self, moduleWithSystem, ... }: {
  flake.nixosModules.zsh = moduleWithSystem ({ pkgs, ... }: {
    imports = with self.nixosModules; [
      bat
      eza
      zoxide
      starship
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      histSize = 10000;

      shellAliases = {
        os-build = "nh os build && exec zsh";
        os-test = "nh os test && exec zsh";
        os-switch = "nh os switch && exec zsh";
        os-update = "nh os switch --update && exec zsh";
        os-clean = "nh clean all --keep 3";

        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";

        fd = "z";
        fdi = "zi";
        yz = "yazi";
        xo = "xdg-open";
        microfetch = "microfetch && echo";
        nd = "nix develop -c $SHELL";

        rm = "echo 'use trash instead'";
        tsp = "customtrash";
        tsl = "trash list";
        tsr = "trash list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trash restore --match=exact --force";

        ls = "eza --group-directories-first --header --icons --git";
        ll = "eza -l --group-directories-first --header --icons --git";
        cat = "bat";
      };

      promptInit = ''
        eval "$(starship init zsh)"
      '';

      interactiveShellInit = ''
        export STUDY_DIR="$HOME/study"

        bindkey '^H' backward-delete-word
        customtrash() { command trash put "$@" }

        typeset -U path

        eval "$(zoxide init zsh)"
        eval "$(direnv hook zsh 2>/dev/null)" || true
      '';
    };

    users.defaultUserShell = pkgs.zsh;

    environment.systemPackages = [
      (pkgs.runCommandLocal "zsh-scripts" { } ''
        mkdir -p $out/bin
        cp ${./scripts/create-subject} $out/bin/create-subject
        cp ${./scripts/hotspot} $out/bin/hotspot
        cp ${./scripts/nvidia-offload} $out/bin/nvidia-offload
        chmod +x $out/bin/*
      '')
    ];
  });
}
