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
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs outputs;};
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
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
      appimage-run # Runs AppImages on NixOS
      bashInteractive # Shell
      btop # Resource management
      btrfs-progs # BTRFS management
      coreutils # GNU utilities
      dmidecode # Hardware information
      efibootmgr # EFI boot entry manager
      exiftool # Image information
      ffmpeg-full # Audio and video processing
      file # File type information
      gdu # Disk usage analyzer
      git # Version control
      hdparm # Disk information
      imagemagick # Image processing
      inetutils # Network utilities
      inxi # System information
      iputils # Network utilities
      jq # JSON CLI parser
      lazygit # TUI Git client
      lm_sensors # Hardware sensors
      logrotate # Rotates and compresses system logs
      lshw # Hardware management
      lsof # Tool to list open files
      netcat # TCP/IP swiss army knife
      nix-index # Nix file database
      nix-tree # Nix store explorer
      nmap # Network scanner
      p7zip # 7-Zip archive management
      ranger # File explorer
      rar # Rar archive management
      smartmontools # Disk management
      strace # Syscall diagnostic and debug tool
      sysstat # Performance monitoring utilities
      tcpdump # Network sniffer
      tmux # Terminal multiplexer
      tree # Depth indented dir listing
      unrar # Rar archive management
      unzip # Zip archive management
      usbutils # USB management
      vim # Text editor
      yq # YAML CLI parser
      zip # Zip archive management
    ];
  };
}