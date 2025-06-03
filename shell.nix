{pkgs ? import <nixpkgs> {}, ...}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      alejandra
      nix
      nixd
      home-manager
      git

      age
      gnupg
      sops
      ssh-to-age
    ];
  };
}