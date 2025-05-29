# hosts/xps/disko.nix

# Declarative partitioning and formatting using disko.
{ lib, ... }: # Add lib if you need helper functions later.

{
  disko.devices = {
    disk.main = {
      device = "/dev/nvme0n1"; # Your target device.
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            size = "512M";
            type = "EF00"; # ESP partition type code.
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot"; # Mount point for the ESP.
            };
          };
          swap = {
            size = "38G";
            content = {
              type = "swap";
              resumeDevice = true; # Enables hibernation support (disko sets boot.resumeDevice).
            };
          };
          root = {
            name = "root";
            type = "8300"; # Linux filesystem type code.
            size = "100%";
            content = {
              type = "btrfs";
              subvolumes = {
                # Note: disko automatically names BTRFS subvolumes (e.g., @root).
                # It uses these mountpoints to generate the 'fileSystems' options.
                "/root" = {
                  mountOptions = [ "compress=zstd" "noatime" ];
                  mountpoint = "/";
                };
                "/persist" = {
                  mountOptions = [ "compress=zstd" "noatime" ];
                  mountpoint = "/persist"; # Useful for data surviving reinstalls.
                };
                "/nix" = {
                  mountOptions = [ "compress=zstd" "noatime"];
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
  };
}