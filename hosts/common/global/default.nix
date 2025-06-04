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
      bashInteractive # Shell
      btrfs-progs # BTRFS management
      coreutils # GNU utilities
      ffmpeg-full # Audio and video processing
      file # File type information
      git # Version control
      jq # JSON CLI parser
      lm_sensors # Hardware sensors
      logrotate # Rotates and compresses system logs
      p7zip # 7-Zip archive management
      rar # Rar archive management
      tree # Depth indented dir listing
      unrar # Rar archive management
      unzip # Zip archive management
      zip # Zip archive management
    ];
  };
}
