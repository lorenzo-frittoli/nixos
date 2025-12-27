{
  description = "System configuration based on https://github.com/Andrey0189/nixos-config-reborn";
  # REMEMBER TO UPDATE ALL VERSIONS
  # current version = 25.05;
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-auth = {
      url = "github:numtide/nix-auth";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      homeStateVersion = "25.05";
      user = "frittata";
      hosts = [
        {
          hostname = "calcolatore";
          stateVersion = homeStateVersion;
        }
      ];

      # --- 1. DEFINE THE OVERLAY ---
      # This creates a namespace "pkgs.unstable" that holds the unstable packages
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = system;
          config.allowUnfree = true;
        };
      };

      makeSystem =
        {
          hostname,
          stateVersion,
        }:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit
              inputs
              stateVersion
              hostname
              user
              ;
          };

          modules = [
            (
              {
                config,
                pkgs,
                ...
              }:
              {
                # --- 2. REGISTER THE OVERLAY HERE ---
                nixpkgs.overlays = [ overlay-unstable ];

                nixpkgs.config.allowUnfree = true;
              }
            )

            ./hosts/${hostname}/configuration.nix
            inputs.disko.nixosModules.disko
          ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.foldl' (
        configs: host:
        configs
        // {
          "${host.hostname}" = makeSystem {
            inherit (host) hostname stateVersion;
          };
        }
      ) { } hosts;

      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs homeStateVersion user;
        };

        modules = [
          # If you want unstable in Standalone Home-Manager, you need to add the overlay here too:
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [ overlay-unstable ];
            }
          )
          ./home-manager/home.nix
        ];
      };
    };
}
