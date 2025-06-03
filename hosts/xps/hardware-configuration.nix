{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel

    ../common/optional/ephemeral-btrfs.nix
  ];
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "uas"
        "usbhid"
        "sd_mod"
        "ahci"
      ];
      kernelModules = ["kvm-intel"];
    };
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
    kernelParams = ["console=tty1"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  fileSystems."/media/storage" = {
    device = "/dev/disk/by-label/storage";
    fsType = "btrfs";
    options = ["subvol=@" "noatime" "compress=zstd"];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8196;
    }
  ];

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}