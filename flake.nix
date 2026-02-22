{
  description = "System configuration based on https://github.com/Andrey0189/nixos-config-reborn";
  # REMEMBER TO UPDATE ALL VERSIONS
  # current version = 25.11;
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    homeStateVersion = "25.05";
    user = "frittata";
    targets = [
      (import ./targets/calcolatore/properties.nix)
    ];

    # --- 1. DEFINE THE OVERLAY ---
    # This creates a namespace "pkgs.unstable" that holds the unstable packages
    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        system = system;
        config.allowUnfree = true;
      };
    };

    makeSystem = {
      hostname,
      stateVersion,
      hasGui,
    }:
      nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit
            inputs
            stateVersion
            hostname
            user
            hasGui
            ;
        };

        modules = [
          (
            {
              config,
              pkgs,
              ...
            }: {
              # --- 2. REGISTER THE OVERLAY HERE ---
              nixpkgs.overlays = [overlay-unstable];

              nixpkgs.config.allowUnfree = true;
            }
          )

          ./targets/${hostname}/default.nix
          inputs.disko.nixosModules.disko
        ];
      };
  in {
    nixosConfigurations =
      nixpkgs.lib.foldl' (
        configs: target:
          configs
          // {
            "${target.hostname}" = makeSystem {
              inherit (target) hostname hasGui;
              stateVersion = homeStateVersion;
            };
          }
      ) {}
      targets;

    homeConfigurations =
      nixpkgs.lib.foldl' (
        configs: target:
          configs
          // {
            "${user}@${target.hostname}" = home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.${system};
              extraSpecialArgs = {
                inherit inputs homeStateVersion user;
                hasGui = target.hasGui;
              };

              modules = [
                (
                  {
                    config,
                    pkgs,
                    ...
                  }: {
                    nixpkgs.overlays = [overlay-unstable];
                  }
                )
                ./home-manager/default.nix
              ];
            };
          }
      ) {}
      targets;
  };
}
