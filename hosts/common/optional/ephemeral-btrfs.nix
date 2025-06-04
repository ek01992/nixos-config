{
  lib,
  config,
  ...
}: let
  hostname = config.networking.hostName;
  phase1Systemd = config.boot.initrd.systemd.enable;
  wipeScript = ''
    mkdir /tmp -p
    MNTPOINT=$(mktemp -d)
    (
      mount -t btrfs -o subvol=/ /dev/disk/by-label/${hostname} "$MNTPOINT"
      trap 'umount "$MNTPOINT"' EXIT

      echo "Creating needed directories"
      mkdir -p "$MNTPOINT"/persist/var/{log,lib/{nixos,systemd}}

      echo "Cleaning root subvolume"
      btrfs subvolume list -o "$MNTPOINT/@" | cut -f9 -d ' ' | sort |
      while read -r subvolume; do
        btrfs subvolume delete "$MNTPOINT/$subvolume"
      done && btrfs subvolume delete "$MNTPOINT/@"

      echo "Restoring blank subvolume"
      btrfs subvolume snapshot "$MNTPOINT/@blank" "$MNTPOINT/@"
    )
  '';
in {
  boot.initrd = {
    supportedFilesystems = ["btrfs"];
    postDeviceCommands = lib.mkIf (!phase1Systemd) (lib.mkBefore wipeScript);
    systemd.services.restore-root = lib.mkIf phase1Systemd {
      description = "Rollback btrfs rootfs";
      wantedBy = ["initrd.target"];
      requires = [
        "dev-disk-by\\x2dlabel-${hostname}.device"
      ];
      after = [
        "dev-disk-by\\x2dlabel-${hostname}.device"
        "systemd-cryptsetup@${hostname}.service"
      ];
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = wipeScript;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = ["subvol=@" "compress=zstd"];
    };

    "/nix" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = ["subvol=@nix" "noatime" "compress=zstd"];
    };

    "/persist" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = ["subvol=@persist" "compress=zstd"];
      neededForBoot = true;
    };

    "/swap" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = ["subvol=@swap" "noatime"];
    };
  };
}
