{ lib, ... }: let
  userfile = import ../../_lib/userfile.nix { inherit lib; };
in {
  flake.nixosModules.hypridle = { pkgs, ... }: let
    conf = pkgs.writeText "hypridle.conf" ''
      general {
          before_sleep_cmd = loginctl lock-session
          after_sleep_cmd = hyprctl dispatch dpms on
          ignore_dbus_inhibit = false
          lock_cmd = pidof hyprlock || hyprlock
      }

      listener {
          timeout = 180
          on-timeout = brightnessctl -s set 30
          on-resume = brightnessctl -r
      }

      listener {
          timeout = 300
          on-timeout = loginctl lock-session
      }

      listener {
          timeout = 600
          on-timeout = hyprctl dispatch dpms off
          on-resume = hyprctl dispatch dpms on
      }
    '';
  in {
    environment.systemPackages = [ pkgs.hypridle ];
  }
  // userfile {
    user = "frittata";
    file = ".config/hypr/hypridle.conf";
    source = conf;
  };
}
