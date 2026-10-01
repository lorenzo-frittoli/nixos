{ inputs, ... }: {
  config = {
    systems = [ "x86_64-linux" ];

    # Make the flake-parts `perSystem` `pkgs` (used inside `moduleWithSystem`
    # feature modules) match the NixOS-configured one: unfree allowed and the
    # `unstable` overlay present.
    perSystem = { system, ... }: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "electron-39.8.10" ];
        };
        overlays = [
          (final: prev: {
            unstable = import inputs.nixpkgs-unstable {
              system = final.stdenv.hostPlatform.system;
              config.allowUnfree = true;
            };
          })
        ];
      };
    };
  };
}
