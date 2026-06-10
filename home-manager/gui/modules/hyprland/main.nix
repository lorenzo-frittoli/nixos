{config, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    configType = "hyprlang"; # !WARN: DEPRECATED
    settings = {
      env = [
        # Hint Electron apps to use Wayland
        "NIXOS_OZONE_WL,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland"
        "XDG_SCREENSHOTS_DIR,$HOME/screens"
        "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card2"
        "AQ_NO_MODIFIERS,1"
      ];

      monitor = [
        "DP-1,3840x2160@60,0x0,2"
        "eDP-1,1920x1080@144,0x1080,1"
      ];

      "$mainMod" = "ALT";
      "$terminal" = "kitty";
      "$fileManager" = "$terminal -e sh -c 'ranger'";
      "$menu" = "wofi";

      exec-once = [
        "waybar"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      general = {
        gaps_in = config.theme.gaps;
        gaps_out = config.theme.gaps;

        border_size = config.theme.border_size;

        # "col.active_border" = "rgba(d65d0eff) rgba(98971aff) 45deg";
        # "col.inactive_border" = "rgba(3c3836ff)";

        resize_on_border = true;

        allow_tearing = false;
        layout = "master";
      };

      decoration = {
        rounding = config.theme.rounding;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = false;
        };

        blur = {
          enabled = false;
        };
      };

      animations = {
        enabled = true;

        # Beziers
        bezier = [
          "expressiveFastSpatial, 0.42, 1.2, 0.21, 0.90"
          "expressiveSlowSpatial, 0.39, 1.1, 0.35, 0.98"
          "expressiveDefaultSpatial, 0.38, 1.21, 0.22, 1.00"
          "emphasizedDecel, 0.05, 0.7, 0.1, 1"
          "emphasizedAccel, 0.3, 0, 0.8, 0.15"
          "standardDecel, 0, 0, 0, 1"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.52, 0.03, 0.72, 0.08"
        ];

        # Animation Configs
        animation = [
          # Windows
          "windowsIn, 1, 3, emphasizedDecel, popin 80%"
          "windowsOut, 1, 2, emphasizedDecel, popin 90%"
          "windowsMove, 1, 3, emphasizedDecel, slide"
          "border, 1, 10, emphasizedDecel"

          # Layers
          "layersIn, 1, 2.7, emphasizedDecel, popin 93%"
          "layersOut, 1, 2.4, menu_accel, popin 94%"

          # Fade
          "fadeLayersIn, 1, 0.5, menu_decel"
          "fadeLayersOut, 1, 2.7, menu_accel"

          # Workspaces
          "workspaces, 1, 7, menu_decel, slide"

          # Special Workspace
          "specialWorkspaceIn, 1, 2.8, emphasizedDecel, slidevert"
          "specialWorkspaceOut, 1, 1.2, emphasizedAccel, slidevert"
        ];
      };

      input = {
        kb_layout = "us";
        kb_options = ["grp:caps_toggle" "ctrl:swapcaps"];
      };

      gesture = "3, horizontal, workspace";

      dwindle = {
        preserve_split = true;
      };

      master = {
        new_status = "slave";
        new_on_top = true;
        mfact = 0.5;
      };

      misc = {
        vrr = 1; # Enable Variable Refresh Rate (0=off, 1=on, 2=fullscreen only)
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      windowrule = [
        # Removes borders when a window is tiled (not floating) and the only one on the workspace
        # "bordersize 0, floating:0, onworkspace:w[t1]"

        # Showmethekey and mpv ? stuff
        # "float 1,class:(mpv)|(imv)|(showmethekey-gtk)"
        # "move 990 60,size 900 170,pin 1,noinitialfocus,class:(showmethekey-gtk)"
        # "noborder 1,nofocus,class:(showmethekey-gtk)"

        # Static workspace assignments: bind apps to specific numbered or special workspaces
        "workspace special:chats,match:class (ZapZap)"
        "workspace special:chats,match:class (signal)"
        "workspace special:chats,match:class (org.telegram.desktop)"

        # Global rule: Ignore 'maximize' requests from all windows to maintain tiling integrity
        "suppress_event maximize, match:class .* 1"

        # Fix for ghost/empty XWayland windows that sometimes appear and steal focus
        "no_focus 1,match:class ^$,match:title ^$,match:xwayland 1,match:float 1,match:fullscreen 0,match:pin 0"

        # Compatibility hacks for xwaylandvideobridge: makes the helper window invisible and non-intrusive
        "opacity 0.0 override, match:class ^(xwaylandvideobridge)$" # Fully transparent
        "no_anim 1, match:class ^(xwaylandvideobridge)$" # Disable animations
        "no_initial_focus 1, match:class ^(xwaylandvideobridge)$" # Don't focus on launch
        "max_size 1 1, match:class ^(xwaylandvideobridge)$" # Shrink to 1x1 pixel
        "no_blur 1, match:class ^(xwaylandvideobridge)$" # Disable background blur
        "no_focus 1, match:class ^(xwaylandvideobridge)$" # Completely ignore focus
      ];

      workspace = [
        # 'Smart Gaps': Remove all gaps when only one tiled window is visible on the workspace
        # "w[tv1], gapsout:0, gapsin:0"

        # 'Full Screen Gaps': Remove gaps when a window is in fullscreen mode
        "f[1], gapsout:0, gapsin:0"
      ];
    };
  };
}
