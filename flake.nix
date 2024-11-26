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
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, darwin }:
  let
    overlays = [ (import ./overlays) ];

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
    };

    darwinConfigurations = {
      macbook = darwin.lib.darwinSystem {
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
    };

    homeConfigurations = {
      nixos = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgsFor.x86_64-linux;
        modules = [ ./home ];
      };
    };
  };
}
