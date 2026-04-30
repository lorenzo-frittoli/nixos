{
  programs.waybar = {
    enable = true;
    # style = ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["hyprland/language" "custom/weather" "pulseaudio" "battery" "clock" "tray"];
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
            "9" = "󰓃"; # Music/Headphones
            "10" = "󰍛"; # btop
            "magic" = "󰭹"; # Magic/Special (chats)
          };

          persistent-workspaces = {
            "*" = 10;
          };
        };

        "hyprland/language" = {
          format-en = "🇺🇸";
          min-length = 5;
          tooltip = false;
        };

        "custom/weather" = {
          format = " {} ";
          exec = "curl -s 'wttr.in/Tashkent?format=%c%t'";
          interval = 300;
          class = "weather";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-muted = "";
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
          format = "{:%d.%m.%Y - %H:%M}";
          format-alt = "{:%A, %B %d at %R}";
        };

        "tray" = {
          icon-size = 14;
          spacing = 3;
        };
      };
    };
  };
}
