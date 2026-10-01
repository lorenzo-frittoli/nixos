{ ... }: {
  flake.nixosModules.git = { pkgs, ... }: {
    programs.git.enable = true;
    programs.gnupg.agent.enable = true;
    environment.systemPackages = [ pkgs.gh ];
  };
}
