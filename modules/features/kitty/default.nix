{
  inputs,
  moduleWithSystem,
  ...
}: let
  theme = import ../../system/theme/_theme.nix;
  p = theme.palette;
in {
  flake.nixosModules.kitty = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.kitty ];
    environment.sessionVariables.TERMINAL = "kitty";
  });

  perSystem = { pkgs, ... }: {
    packages.kitty = inputs.wrappers.wrappers.kitty.wrap {
      inherit pkgs;
      settings = {
        background_blur = 5;
        window_padding_width = 20;
        confirm_os_window_close = 0;
        enable_audio_bell = false;
        font_family = "JetBrains Mono";
        font_size = 13;
      };
      keybindings = {
        "ctrl+backspace" = "send_text all \\x17";
      };
      extraConfig = ''
        background ${p.base00}
        foreground ${p.base05}
        selection_background ${p.base02}
        selection_foreground ${p.base05}
        cursor ${p.base0D}
        color0 ${p.base00}
        color1 ${p.base08}
        color2 ${p.base0B}
        color3 ${p.base0A}
        color4 ${p.base0D}
        color5 ${p.base0E}
        color6 ${p.base0C}
        color7 ${p.base05}
        color8 ${p.base03}
        color9 ${p.base08}
        color10 ${p.base0B}
        color11 ${p.base0A}
        color12 ${p.base0D}
        color13 ${p.base0E}
        color14 ${p.base0C}
        color15 ${p.base07}
      '';
    };
  };
}
