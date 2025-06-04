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
    createHome = true;
    home = "/home/erik";
  };

  home-manager.users.erik = {
    imports = [
      ../../home/erik/xps
    ];
  };

  system.stateVersion = "25.11";
}