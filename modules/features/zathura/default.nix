{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.zathura = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.zathura ];
  });
  perSystem = { pkgs, ... }: {
    packages.zathura = inputs.wrappers.wrappers.zathura.wrap {
      inherit pkgs;
      settings = {
        font = "JetBrains Mono Bold 13";
      };
      mappings = {
        D = "toggle_page_mode";
        "<C-c>" = "copy_to_clipboard";
      };
    };
  };
}
