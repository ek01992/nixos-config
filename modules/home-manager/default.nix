{ inputs, outputs, ... }: {
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.homeManagerModules.impermanence
  ];

  home-manager = {
    enable = true;
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      erik = import ../../home-manager/users/erik.nix;
    };
  };
}