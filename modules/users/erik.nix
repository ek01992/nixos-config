# modules/users/erik.nix
{ config, pkgs, lib, inputs, home-manager, impermanence, ... }:

{
  # --- USER DEFINITION ---
  users = {
    users =
    let
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPakom6FvoSpBc0nmunHQUZwQI9VtS52i4W4WLuiUMpc ek01992@proton.me"
      ];
    in { 
      erik = {
        isNormalUser = true;
        description = "Erik";
        extraGroups = [ "networkmanager" "wheel" ];
        home = "/home/erik";
        shell = pkgs.zsh;
        initialPassword = "temp";
        openssh.authorizedKeys = {
          inherit keys;
        };
      };
    };
  };

  programs = {
    git.enable = true;
    zsh.enable = true;
  };

  # --- HOME-MANAGER CONFIGURATION ---
  home-manager.users.erik = { pkgs, ... }: {
    imports = [ inputs.impermanence.homeManagerModules.impermanence ];

    home = {
      stateVersion = "25.05";
      homeDirectory = "/home/erik";
  
      persistence."/persist/home/erik" = {
        directories = [
          ".ssh"
          ".gnupg"
          "Documents"
          "Downloads"
          "Pictures"
          "Projects"
        ];
        files = [
          ".zsh_history"
        ];
        allowOther = true;
      };

      packages = with pkgs; [
        fastfetch
        ripgrep
        fd
      ];
    };
    programs = {
      git = {
        enable = true;
        userName = "Erik";
        userEmail = "ek01992@pm.me";
        extraConfig = {
          init.defaultBranch = "main";
          core.editor = "nvim";
        };
      };

      zsh = {
        enable = true;
        autosuggestion.enable = true; 
        enableCompletion = true;
        syntaxHighlighting.enable = true; 
        shellAliases = {
          ll = "ls -l";
          la = "ls -la";
          # update = "sudo nixos-rebuild switch --flake ~/flake#xps";
        };
      };
    };
  };
}