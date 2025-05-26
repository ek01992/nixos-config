{
  modulesPath,
  lib,
  config,
  opts,
  ...
}:
{

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  powerManagement.cpuFreqGovernor = "performance";
  boot = {
    kernelParams = [
    ];
    # extraModprobeConfig = "options i915 enable_guc=2";
    # This is imp as the drive is encrypted.
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "uas"
      "usbhid"
      "sd_mod"
      "thunderbolt"
    ];
    kernelModules = [ "kvm-intel" ];

  };

  services.thermald.enable = true;
  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

}