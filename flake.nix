{
  description = "A flake for timraymond's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helm-complete = {
      url = "github:timraymond/helm-complete";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, darwin, helm-complete}:
  let
    overlays = [
      (import ./overlays)
      helm-complete.overlays.default
    ];

    mkSystem = import ./lib/mk-system.nix;

    # Supported system types
    supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

    # Helper to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    # Nixpkgs instantiated for supported system types.
    nixpkgsFor = forAllSystems (system: import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    });
  in
  {
    nixosConfigurations = {
      wsl = mkSystem {
        inherit nixpkgs home-manager;
        system = "x86_64-linux";
        extraModules = [
          nixos-wsl.nixosModules.default
          ./modules/wsl.nix
          { nixpkgs.overlays = overlays; }
        ];
      };

      eros = mkSystem {
        inherit nixpkgs home-manager;
        system = "x86_64-linux";
        extraModules = [
          ./hosts/eros/hardware-configuration.nix
          ./hosts/eros/configuration.nix
          { nixpkgs.overlays = overlays; }
        ];
      };
    };

    darwinConfigurations = {
      ceres = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./modules/darwin.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = overlays;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."tim" = { pkgs, ... }: {
                imports = [ ./home ];
                home = {
                  username = "tim";
                  homeDirectory = "/Users/tim";
                };
              };
            };
          }
        ];
      };
      tempest = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./modules/darwin.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = overlays;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."tim" = { pkgs, ... }: {
                imports = [ ./home ];
                home = {
                  username = "tim";
                  homeDirectory = "/Users/tim";
                };
              };
            };
          }
        ];
      };
    };

    homeConfigurations = {
      nixos = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgsFor.x86_64-linux;
        modules = [ ./home ];
      };
    };
  };
}
