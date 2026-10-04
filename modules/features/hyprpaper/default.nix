{ lib, ... }: let
  userfile = import ../../_lib/userfile.nix { inherit lib; };
in {
  flake.nixosModules.hyprpaper = { pkgs, ... }: let
    conf = pkgs.writeText "hyprpaper.conf" ''
      splash = false
      wallpaper {
        monitor =
        path = ${../../../static/leslie_gay_2.png}
      }
    '';
  in {
    environment.systemPackages = [ pkgs.hyprpaper ];
  }
  // userfile {
    user = "frittata";
    file = ".config/hypr/hyprpaper.conf";
    source = conf;
  };
}
