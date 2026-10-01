{ ... }: {
  flake.nixosModules.session = { pkgs, ... }: {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks";
        user = "greeter";
      };
    };

    services.displayManager.defaultSession = "hyprland";
  };
}
