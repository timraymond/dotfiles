{ nixpkgs, home-manager, system, extraModules ? [] }:

nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.nixos = import ../home;
    }
  ] ++ extraModules;
}
