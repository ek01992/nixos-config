{
  imports = [
    ./hardware-configuration.nix
    ./services

    ../common/global
  ];

  networking = {
    hostName = "xps";
    useDHCP = true;
  };

  system.stateVersion = "25.05";
}