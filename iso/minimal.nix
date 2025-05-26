# Minimal Iso stands for CLI variant only
{
  inputs,
  pkgs,
  modulesPath,
  self,
  hostPlatform,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    self.nixosMoudles.home-manager
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs = {
    inherit hostPlatform;
  };

  environment = {
    systemPackages =
      with pkgs;
      [
        git
        disko
      ]
      ++ ([
        inputs.nvix.packages.${pkgs.system}.bare # My neovim config based on Nixvim
      ]);
    shellAliases = {
      vim = "nvim";
    };
  };

  networking = {
    networkmanager.enable = true;

    # This does not disable wifi
    # It is just an minimal alternative to Network manager
    wireless.enable = false;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  users.users =
    let
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPakom6FvoSpBc0nmunHQUZwQI9VtS52i4W4WLuiUMpc ek01992@proton.me"
      ];
    in
    {
      root.openssh.authorizedKeys = {
        inherit keys;
      };
      nixos.openssh.authorizedKeys = {
        inherit keys;
      };
    };

}