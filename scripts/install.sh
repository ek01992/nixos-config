#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
# Your GitHub repository for the NixOS configuration.
# You can change this if you fork the repository.
readonly NIXOS_CONFIG_REPO="https://github.com/ek01992/nixos-config.git"

# --- Script Functions ---
log() {
    echo -e "\n---> $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

error() {
    echo -e "\n[ERROR] $1" >&2
    exit 1
}

# --- Main Script ---
# Check for root privileges
if [[ "$EUID" -ne 0 ]]; then
  error "This script must be run as root."
fi

# Check for arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <hostname> <device>"
    echo "Example: $0 xps /dev/nvme0n1"
    exit 1
fi

readonly HOST="$1"
readonly DRIVE="$2"

log "Starting NixOS installation for host '$HOST' on drive '$DRIVE'."

# Safety prompt
echo -e "\n!!! WARNING !!!"
echo "This script will wipe all data on $DRIVE."
echo "This is your final chance to back up your data."
read -p "Are you sure you want to continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log "Installation aborted by user."
    exit 0
fi

log "Partitioning drive $DRIVE..."
printf "label: gpt\n,1500M,U,*\n,,L\n" | sfdisk "$DRIVE"

log "Formatting partitions..."
mkfs.fat -F 32 -n ESP "${DRIVE}p1"
mkfs.btrfs -L "$HOST" "${DRIVE}p2"

log "Creating BTRFS subvolumes..."
mount "/dev/disk/by-label/$HOST" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@persist
btrfs subvolume create /mnt/@swap
btrfs subvolume snapshot -r /mnt/@ /mnt/@blank
umount /mnt

log "Mounting filesystems for installation..."
mount -o "compress=zstd,noatime,subvol=@" "/dev/disk/by-label/$HOST" /mnt
mkdir -p /mnt/{boot,nix,persist,swap,etc}
mount "/dev/disk/by-label/ESP" /mnt/boot
mount -o "compress=zstd,noatime,subvol=@nix" "/dev/disk/by-label/$HOST" /mnt/nix
mount -o "compress=zstd,subvol=@persist" "/dev/disk/by-label/$HOST" /mnt/persist
mount -o "noatime,subvol=@swap" "/dev/disk/by-label/$HOST" /mnt/swap

log "Creating and enabling swapfile..."
btrfs filesystem mkswapfile --size 8196M --uuid clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile

log "Setting up SSH host keys..."
mkdir -p /mnt/persist/etc/ssh
if [[ -f /etc/ssh/ssh_host_ed25519_key ]]; then
    log "Copying existing SSH host keys..."
    cp -av /etc/ssh/ssh_host_*_key* /mnt/persist/etc/ssh/
else
    log "No existing SSH host keys found. Generating new ones."
    ssh-keygen -t rsa -b 4096 -f /mnt/persist/etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /mnt/persist/etc/ssh/ssh_host_ed25519_key -N ""
fi
chmod 600 /mnt/persist/etc/ssh/*_key
chmod 644 /mnt/persist/etc/ssh/*.pub

log "Cloning NixOS configuration into /mnt/etc/nixos..."
git clone "$NIXOS_CONFIG_REPO" /mnt/etc/nixos
cd /mnt/etc/nixos
# It's good practice to update the flake inputs before installing.
# Uncomment the next line if you want to use the latest dependencies.
# nix flake update

log "Installing NixOS..."
nixos-install --root /mnt --flake ".#$HOST" --no-root-passwd

log "Installation finished successfully!"
echo "You can now unmount and reboot the system."
echo "Run: umount -R /mnt && reboot"
