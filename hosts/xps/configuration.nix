# hosts/xps/configuration.nix
#
# This module defines the core configuration for the 'xps' host.
# Thanks to 'specialArgs' in flake.nix, 'inputs' is available here.
{ config, pkgs, lib, inputs, outputs,... }:

{
  # --- IMPORTS ---
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  # --- BOOTLOADER ---
  # Configure how the system boots. systemd-boot is common for UEFI.
  boot = {
    extraModulePackages = [ ];
    kernelModules = [ "kvm-intel" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      systemd.initrdBin = with pkgs; [ btrfs-progs coreutils ];
      supportedFilesystems = [ "btrfs" ];
      kernelModules = [ "btrfs" ];
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "uas"
        "usbhid"
        "sd_mod"
      ];
    };
  };

  # --- FILE SYSTEMS ---
  fileSystems = {
    "/persist" = {
      neededForBoot = true;
    };
  };

  # --- NETWORKING ---
  networking = {
    hostName = "xps"; # Set your desired hostname.
    networkmanager.enable = true; # Use NetworkManager for easy WiFi/Ethernet.
    useDHCP = lib.mkDefault true;
  };

  # --- LOCALIZATION ---
  time.timeZone = "America/Chicago"; # Set your timezone.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # --- NIX SETTINGS ---
  # Enable flakes and the new command-line interface.
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    # Optional: Configure garbage collection.
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # --- SERVICES ---
  # Enable necessary services, like SSH.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  # Disable mutable users. to prevent users from being created or modified.
  users.mutableUsers = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # --- SYSTEM STATE ---
  # This value determines the compatibility level for NixOS configuration.
  # It's set during installation and should generally not be changed
  # unless you are explicitly migrating your system.
  system.stateVersion = "25.05"; # Or "23.11", or "unstable". Match your intent.
}