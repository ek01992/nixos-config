{
  imports = [
    ./hardware-configuration.nix
    ./services
    ../common/users/erik
    ../common/global
  ];

  networking = {
    hostName = "xps";
    useDHCP = true;
  };

  system.stateVersion = "25.11";
}
