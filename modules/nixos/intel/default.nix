{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  hardware = {
    cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
  };
}