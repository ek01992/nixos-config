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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPakom6FvoSpBc0nmunHQUZwQI9VtS52i4W4WLuiUMpc ek01992@proton.me"
    ];
  };
  users.mutableUsers = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  home-manager.users.erik = {
    imports = [
      ../../home/erik/xps
    ];
  };

  system.stateVersion = "25.11";
}