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

  users.users.erik = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "temp";
  };

  system.stateVersion = "25.05";
}