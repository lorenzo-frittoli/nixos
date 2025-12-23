{ user, ... }:
{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 10";
    flake = "/home/${user}/nixos"; # Sets NH_FLAKE env variable
  };
}
