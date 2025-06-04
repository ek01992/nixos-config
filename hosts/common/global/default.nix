{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./fonts.nix
      ./locale.nix
      ./nix.nix
      ./persistence.nix
      ./sudo.nix
      ./ssh.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs outputs;};
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  networking = {
    firewall.enable = true;
    nftables.enable = true;
  };

  hardware.enableRedistributableFirmware = true;

  environment = {
    defaultPackages = lib.mkForce [];
    systemPackages = with pkgs; [
      bashInteractive
      btrfs-progs
      coreutils
      ffmpeg
      file
      git
      jq
      lm_sensors
      logrotate
      p7zip
      rar
      tree
      unrar
      unzip
      zip
    ];
  };
}
