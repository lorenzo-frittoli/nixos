{ lib, ... }: {
  flake.nixosModules.theme = { pkgs, ... }: {
    options.theme = {
      gaps = lib.mkOption {
        type = lib.types.int;
        default = 5;
      };
      rounding = lib.mkOption {
        type = lib.types.int;
        default = 5;
      };
      border_size = lib.mkOption {
        type = lib.types.int;
        default = 2;
      };
    };

    config = {
      environment.systemPackages = with pkgs; [
        vanilla-dmz
        adwaita-icon-theme
        papirus-icon-theme
      ];
      environment.sessionVariables = {
        XCURSOR_THEME = "DMZ-Black";
        XCURSOR_SIZE = "24";
        GTK_THEME = "Adwaita:dark";
      };

      qt = {
        enable = true;
        platformTheme = "gtk2";
        style = "adwaita-dark";
      };
    };
  };
}
