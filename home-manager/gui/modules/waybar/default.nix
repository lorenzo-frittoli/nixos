{config, ...}: let
  gaps = toString config.theme.gaps;
  rounding = toString config.theme.rounding;
  border_size = toString config.theme.border_size;
in {
  programs.waybar = {
    enable = true;
    style = ''
         @define-color base00 ${config.lib.stylix.colors.withHashtag.base00};
         @define-color base01 ${config.lib.stylix.colors.withHashtag.base01};
         @define-color base05 ${config.lib.stylix.colors.withHashtag.base05};
         @define-color base08 ${config.lib.stylix.colors.withHashtag.base08};
         @define-color base09 ${config.lib.stylix.colors.withHashtag.base09};
         @define-color base0A ${config.lib.stylix.colors.withHashtag.base0A};
         @define-color base0B ${config.lib.stylix.colors.withHashtag.base0B};
         @define-color base0C ${config.lib.stylix.colors.withHashtag.base0C};
         @define-color base0D ${config.lib.stylix.colors.withHashtag.base0D};
         @define-color base0E ${config.lib.stylix.colors.withHashtag.base0E};

      /* Inactive is 80% opacity (cc in hex = 0.8) */
         @define-color active_border ${config.lib.stylix.colors.withHashtag.base0D};
         @define-color inactive_border alpha(${config.lib.stylix.colors.withHashtag.base03}, 0.8);

         window#waybar {
           border: ${border_size}px solid @inactive_border;
           border-radius: ${rounding}px;
         }

         ${builtins.readFile ./style.css}
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        margin = "${gaps} ${gaps} 0 ${gaps}";
        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "backlight" "battery"];
        "hyprland/workspaces" = {
          disable-scroll = true;
          show-special = true;
          special-visible-only = true;
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            "1" = "󰈹"; # Browser
            "2" = "󰏫"; # Neovim
            "3" = ""; # Terminal
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

          /*
          persistent-workspaces = {
            "*" = 10;
          };
          */
        };

        "custom/weather" = {
          format = " {} ";
          exec = "curl -s 'wttr.in/Pisa?format=%c%t'";
          interval = 300;
          class = "weather";
        };

        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = ["󰃞" "󰃟" "󰃠"];
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-muted = "{icon} MUT";
          format-icons = {
            "headphones" = "󰋋";
            "handsfree" = "󰋎";
            "headset" = "󰋎";
            "phone" = "󰏲";
            "portable" = "󰏲";
            "car" = "󰄄";
            "default" = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "pavucontrol";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 1;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        "clock" = {
          format = "{:%H:%M - %a, %d/%m}";
        };

        "tray" = {
          icon-size = 14;
          spacing = 3;
        };
      };
    };
  };
}
