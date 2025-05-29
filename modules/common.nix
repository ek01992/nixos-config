# modules/common.nix
{ config, pkgs, lib, inputs, ... }: {
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  /*
  boot.initrd.postDeviceCommands = lib.mkBefore ''
    # --- BTRFS SNAPSHOT ROLLBACK SCRIPT ---
    # Runs *before* the main root is mounted. Archives the old 'root'
    # subvolume and creates a fresh one.
    
    # Enable debugging output in initrd logs (check with 'journalctl')
    set -x

    # Define the BTRFS device. WARNING: Hardcoded based on disko.nix.
    BTRFS_DEV="/dev/disk/by-partlabel/disk-main-root"

    echo "Starting BTRFS root rollback on $BTRFS_DEV..."
    mkdir -p /btrfs_tmp

    # Mount the top-level BTRFS volume (subvolid=5 is standard for top-level).
    mount -o subvolid=5,defaults "$BTRFS_DEV" /btrfs_tmp

    if ! mountpoint -q /btrfs_tmp; then
      echo "FATAL: BTRFS mount on $BTRFS_DEV failed! Cannot proceed."
      # You might want a 'halt' or 'reboot' or drop to emergency shell here.
      exit 1
    fi

    # Check if a 'root' subvolume exists (this matches your disko setup).
    if [[ -e /btrfs_tmp/root ]]; then
      echo "Archiving existing /btrfs_tmp/root..."
      mkdir -p /btrfs_tmp/old_roots

      timestamp=$(stat -c %Y /btrfs_tmp/root 2>/dev/null) || timestamp=$(date +%s)
      formatted_timestamp=$(date --date="@$timestamp" "+%Y-%m-%d_%H-%M-%S")
      archive_path="/btrfs_tmp/old_roots/$formatted_timestamp"

      mv /btrfs_tmp/root "$archive_path"
      echo "Archived to $archive_path."
    else
      echo "/btrfs_tmp/root does not exist. Skipping archive."
    fi

    # Recursive delete function (use with caution!)
    delete_subvolume_recursively() {
      local subvol_path="$1"
      # Ensure it exists and looks like a dir before proceeding.
      if [[ ! -d "$subvol_path" ]]; then return 0; fi

        echo "Checking for subvolumes under $subvol_path..."
        btrfs subvolume list -o "$subvol_path" | grep -v " $subvol_path\$" | while IFS= read -r line; do
          # Extract the path part. The output of 'btrfs subvolume list -o' has the path starting at column 9.
          local item_to_delete="/btrfs_tmp/$(echo "$line" | cut -f 9- -d ' ')"
          # Ensure no leading/trailing whitespace issues if any (though cut usually handles this well)
          item_to_delete=$(echo "$item_to_delete" | xargs)
          delete_subvolume_recursively "$item_to_delete"
        done

        echo "Deleting $subvol_path..."
        btrfs subvolume delete "$subvol_path" || echo "WARNING: Failed to delete $subvol_path"
    }

    echo "Cleaning up roots older than 30 days..."
    # Ensure 'find' works as expected in initrd. Use -print0 for safety.
    find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30 -print0 | while IFS= read -r -d $'\0' old_root; do
      echo "Found old root: $old_root"
      delete_subvolume_recursively "$old_root"
    done

    echo "Creating new /btrfs_tmp/root subvolume..."
    btrfs subvolume create /btrfs_tmp/root

    echo "Unmounting BTRFS top-level..."
    umount /btrfs_tmp
    echo "BTRFS root rollback complete."
    set +x
  '';
  */
  
  # --- IMPERMANENCE (System-Level) ---
  environment.persistence."/persist" = {
    directories = [
      "/etc/ssh"
      "/var/log"
      "/var/lib"
      "/etc/nix"
      "/etc/nixos"
      "/etc/nixos-config"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  # --- SHARED PACKAGES / SETTINGS ---
  # Add any other system-wide settings or packages all hosts should have.
  environment.systemPackages = with pkgs; [
    git
    neovim # Or your preferred editor.
    wget
    curl
    # Add essential command-line tools here.
  ];

  # Allow unfree packages if needed (e.g., for drivers, certain apps).
  # nixpkgs.config.allowUnfree = true;
}