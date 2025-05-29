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

  outputs = { self, nixpkgs, disko, home-manager, impermanence, ... } @ inputs: 
  let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    nixosConfigurations = {
      xps = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; }; # Pass all inputs down.
        modules = [
          ./hosts/xps/configuration.nix
        ];
      };
    };
  };
}