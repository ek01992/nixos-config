# My NixOS Flake Configuration

A minimal, modular, and impermanent NixOS setup for the 'xps' host. This configuration uses Flakes, Disko for declarative partitioning, a BTRFS snapshot-based impermanence strategy, and Home-Manager for user environment management.

## Philosophy

This setup aims for a reproducible and resilient system. The root filesystem is reset on every boot (using BTRFS snapshots), while essential system state and user data are preserved via `impermanence` linking to a persistent BTRFS subvolume (`/persist`).

## Prerequisites

* NixOS Installation Media (>= 23.11 recommended, or any version with Flakes support & `git`).
* Working internet connection within the installer environment.
* The target disk (`/dev/nvme0n1` in this config) **ready to be completely wiped**.
* Your NixOS configuration files available (e.g., via `git`).

## Installation Instructions

**:warning: DANGER :warning:**
The following steps will **ERASE ALL DATA** on the disk specified in `hosts/xps/disko.nix` (currently `/dev/nvme0n1`). **BACK UP YOUR DATA** before proceeding.

### Step 1: Prepare the Installer Environment

1. Boot from the NixOS USB/ISO.
2. Ensure you have a terminal/console open.
3. Switch to the `root` user for convenience:

    ```bash
    sudo -i
    ```

4. Verify internet connection:

    ```bash
    ping -c 3 nixos.org
    ```

5. Clone this repository (replace `<your-repo-url>`):

    ```bash
    git clone <your-repo-url> /tmp/flake
    ```

6. Navigate into the repository:

    ```bash
    cd /tmp/flake
    ```

7. **(Optional but Recommended)** Review `hosts/xps/disko.nix` and `modules/common.nix` one last time to ensure the target device (`/dev/nvme0n1`) and BTRFS device path (`/dev/disk/by-partlabel/root`) are correct for your hardware.

### Step 2: About the BTRFS Rollback Script

Our setup uses a script (`boot.initrd.postDeviceCommands`) to achieve impermanence by resetting the `root` BTRFS subvolume on each boot.

* **When to activate?** You *can* install with it active, but it makes the very first boot more complex to troubleshoot. If anything goes wrong (the script, impermanence links, etc.), the system might not boot correctly.
* **Recommendation:** Perform the initial installation **without** the script. Boot once, verify basic functionality, and *then* enable the script and rebuild. This isolates potential problems.

### Step 3: Choose Your First-Boot Strategy

**Option A (Recommended): Install *Without* Rollback Script**

1. **Edit `modules/common.nix`:** Open the file in an editor (e.g., `nano modules/common.nix`).
2. **Comment Out:** Find the `boot.initrd.postDeviceCommands = lib.mkBefore '' ... '';` block and comment it out entirely using Nix comments (`#` for single lines, or `/* ... */` for the block).

    ```nix
    # boot.initrd.postDeviceCommands = lib.mkBefore ''
    #  set -x # Enable debugging output in initrd logs (check with 'journalctl')
    #  ... (rest of the script) ...
    #  set +x
    # '';
    ```

3. Save and close the file.

**Option B: Install *With* Rollback Script**

1. Ensure the `boot.initrd.postDeviceCommands` block in `modules/common.nix` is **uncommented**.
2. Be prepared for the first boot to immediately "wipe" the root (by replacing it with a fresh one) and rely on `impermanence` for setup.

### Step 4: Run Disko (Partition & Format)

1. Execute `disko`. This reads `hosts/xps/disko.nix` and applies the partitioning/formatting scheme.

    ```bash
    nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko .#xps
    ```

2. **Verify Mounts:** `disko` should mount your new filesystems under `/mnt`. Check this:

    ```bash
    ls -l /mnt
    # Expected output: /mnt, /mnt/boot, /mnt/nix, /mnt/persist (and maybe others)
    ```

    If `/mnt` is empty or missing expected directories, `disko` likely failed. Review its output carefully.

### Step 5: Install NixOS

1. Run `nixos-install`. This installs the system defined in your flake onto the prepared disks.

    ```bash
    nixos-install --flake .#xps
    ```

    This step will download and build many packages and can take a significant amount of time.

### Step 6: First Boot & Configuration

1. Once `nixos-install` completes without errors, reboot:

    ```bash
    reboot
    ```

2. Remove the installation media when prompted.
3. Log in as `erik` with the initial password (`temp` or whatever you set).
4. **IMMEDIATELY change your password:**

    ```bash
    passwd erik
    ```

5. Test basic functionality (networking, display, etc.).

### Step 7: Enable BTRFS Rollback (If you chose Option A)

1. If you installed via Option A, you now need to enable the BTRFS script.
2. **Access Your Config:** You'll need to edit your flake files. You might want to clone them again into a persistent location (e.g., `git clone <your-repo-url> /persist/home/erik/Projects/nixconfig`) or edit them via SSH/other means.
3. **Uncomment:** Edit `modules/common.nix` and uncomment the `boot.initrd.postDeviceCommands` block.
4. **Rebuild:** Navigate to your flake directory and run:

    ```bash
    sudo nixos-rebuild switch --flake .#xps
    ```

5. **Test:** Reboot your system:

    ```bash
    reboot
    ```

6. Your system should now boot using the BTRFS rollback script. Log in and verify that your system works and that data in persistent locations (like `~/Documents` if persisted) is still present.

## Post-Installation Management

* **Applying Changes:** Edit your configuration files and run `sudo nixos-rebuild switch --flake .#xps`.
* **Updating Inputs:** To get newer versions of NixOS, Home-Manager, etc., run `nix flake update` in your flake directory, then rebuild.

## Troubleshooting

* **Boot Issues:** If the system doesn't boot, especially after enabling the BTRFS script, boot from the NixOS ISO again. You can try mounting your BTRFS partition (`mount /dev/disk/by-partlabel/root /mnt`) and inspecting the subvolumes (`btrfs subvolume list /mnt`) and logs within `/mnt/persist/var/log` (if you mounted `/persist`). Checking `journalctl` on the *next* boot attempt can also reveal issues from the *previous* boot's initrd phase.
* **Persistence Issues:** If data isn't being saved, double-check your `environment.persistence` and `home.persistence` configurations and ensure the symlinks/bind mounts are being created correctly in `/` and `/home/erik`.
