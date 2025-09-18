{ user, ... }: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 3";
    flake = "/home/${user}/nixos-config-reborn";
  };
}
