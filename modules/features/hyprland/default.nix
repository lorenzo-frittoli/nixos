{ lib, ... }: let
  userfile = import ../../_lib/userfile.nix { inherit lib; };
in {
  flake.nixosModules.hyprland =
    { pkgs, ... }: {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
      security.pam.services.hyprlock = { };
      environment.systemPackages = [ pkgs.hyprsunset ];
    }
    // userfile {
      user = "frittata";
      file = ".config/hypr/hyprland.conf";
      source = ./hyprland.conf;
    };
}
