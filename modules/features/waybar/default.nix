{
  inputs,
  moduleWithSystem,
  ...
}: let
  theme = import ../../system/theme/_theme.nix;
  p = theme.palette;
in {
  flake.nixosModules.waybar = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.waybar ];
  });

  perSystem = { pkgs, ... }: {
    packages.waybar = inputs.wrappers.wrappers.waybar.wrap {
      inherit pkgs;
      settings = {
        layer = "top";
        position = "top";
        height = 32;
        margin = "${toString theme.gaps} ${toString theme.gaps} 0 ${toString theme.gaps}";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "backlight" "battery" "tray" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          show-special = true;
          special-visible-only = true;
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            "1" = "󰈹";
            "2" = "󰏫";
            "3" = "";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
            "magic" = "";
            "chats" = "󰭹";
            "music" = "󰓃";
            "btop" = "󰍛";
            "todo" = "";
          };
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-muted = "{icon} MUT";
          format-icons = {
            headphones = "󰋋";
            handsfree = "󰋎";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰏲";
            car = "󰄄";
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
        };

        battery = {
          states = {
            warning = 30;
            critical = 1;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        clock.format = "{:%H:%M - %a, %d/%m}";
        tray = {
          icon-size = 14;
          spacing = 3;
        };
      };
      "style.css".content = ''
        @define-color base00 ${p.base00};
        @define-color base01 ${p.base01};
        @define-color base02 ${p.base02};
        @define-color base03 ${p.base03};
        @define-color base05 ${p.base05};
        @define-color base0D ${p.base0D};
        @define-color active_border ${p.base0D};
        @define-color inactive_border ${p.base03};
      '' + builtins.readFile ./style.css;
    };
  };
}
