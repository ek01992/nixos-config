# flake.nix
{
  description = "Minimal, Modular NixOS Flake with Disko, Impermanence, and Home-Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add home-manager.
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add impermanence.
    impermanence = {
      url = "github:nix-community/impermanence";
      # No 'follows' needed here, it uses its own nixpkgs usually.
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, impermanence, ... }@inputs: {

    nixosConfigurations = {
      xps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Pass all inputs down.
        modules = [
          disko.nixosModules.default
          ./hosts/xps/partition.nix
          ./hosts/xps/configuration.nix
          ./modules/common.nix
          home-manager.nixosModules.home-manager
          ./modules/users/erik.nix

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}