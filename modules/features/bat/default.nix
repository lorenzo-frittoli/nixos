{ ... }: {
  flake.nixosModules.bat = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.bat ];
    environment.sessionVariables.BAT_THEME = "gruvbox-dark";
  };
}
