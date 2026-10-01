{
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.neovim = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.neovim ];
  });
  perSystem = { pkgs, ... }: let
    wrap = import ../../_lib/wrap.nix { inherit pkgs; lib = pkgs.lib; };
    configDir = pkgs.runCommandLocal "nvim-config" { } ''
      mkdir -p $out
      cp -r ${./config} $out/nvim
    '';
  in {
    packages.neovim = wrap {
      package = pkgs.neovim;
      bin = "nvim";
      env = { XDG_CONFIG_HOME = configDir; };
    };
  };
}
