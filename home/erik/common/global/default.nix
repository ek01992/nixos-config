{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: {
  imports =
    [
      inputs.impermanence.nixosModules.home-manager.impermanence
      ./cli
    ]
    ++ builtins.attrValues outputs.homeManagerModules;


  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };

  home = {
    username = lib.mkDefault "erik";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    sessionPath = ["$HOME/.local/bin"];
    sessionVariables = {NH_FLAKE = "$HOME/workspace/nixos";};
  };

  home.persistence = {
    "/persist/${config.home.homeDirectory}" = {
      allowOther = true;
      directories = [
        "desktop"
        "documents"
        "downloads"
        "music"
        "nixos-config"
        "pictures"
        "public"
        "templates"
        "videos"
        "workspace"
        ".local/bin"
        ".local/share/nix"
      ];
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    git.enable = true;
    home-manager.enable = true;
  };
}