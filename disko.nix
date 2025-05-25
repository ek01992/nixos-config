{
  device ? throw "Set this to your disk device, e.g. /dev/sda",
  ...
}: {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          swap = {
            size = "38G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          root = {
            name = "root";
            type = "8300";
            size = "100%";
            content = {
              type = "btrfs";
              subvolumes = {
                "/root" = {
                  mountOptions = [ "compress=zstd" "noatime" "subvol=root" ];
                  mountpoint = "/";
                };
                "/persist" = {
                  mountOptions = [ "compress=zstd" "noatime" "subvol=persist" ];
                  mountpoint = "/persist";
                };
                "/nix" = {
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "noacl"
                  ];
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
