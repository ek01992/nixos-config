{
  inputs,
  pkgs,
  lib,
  self,
  config,
  ...
}:
with lib;
{
  imports =
    with builtins;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    )
    ++ (builtins.attrValues self.nixosModules)
    ++ [
      ../impermanence.nix # to make common dir permanent
    ];

  ndots = {
    # sec.askPass = false;
    disk.device = "/dev/nvme0n1";
    # hardware.opentabletdriver = false;
    disk.impermanence = true;
    # disk.encrypted = false;
    networking.firewall = false;
    networking.stevenblack = false;
    networking.ssh = true;
    # boot.secureboot = false;
    networking.timezone = "America/Chicago";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
}