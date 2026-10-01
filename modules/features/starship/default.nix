{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.starship = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.starship ];
  });
  perSystem = { pkgs, ... }: {
    packages.starship = inputs.wrappers.wrappers.starship.wrap {
      inherit pkgs;
      settings = {
        add_newline = true;
        hostname = {
          ssh_only = false;
          format = "[$ssh_symbol$hostname]($style) ";
          style = "bold purple";
        };
        character = {
          success_symbol = "[ & ](bold green)";
          error_symbol = "[ & ](bold red)";
        };
        username = {
          show_always = true;
          format = "[$user]($style)@";
        };
        directory = {
          read_only = " 🔒";
          truncation_symbol = "…/";
        };
      };
    };
  };
}
