{
  pkgs,
  config,
  ...
}: let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.groups.erik.gid = 1000;
  users.users.erik = {
    uid = 1000;
    isNormalUser = true;
    home = "/home/erik";
    createHome = true;
    shell = pkgs.bash;
    group = "erik";
    extraGroups =
      [
        "wheel"
        "users"
        "audio"
        "video"
      ]
      ++ ifTheyExist [
        "networkmanager"
      ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPakom6FvoSpBc0nmunHQUZwQI9VtS52i4W4WLuiUMpc ek01992@proton.me"
    ];
    initialPassword = "temp";
    packages = with pkgs; [home-manager];
  };

  home-manager.users.erik = import ../../../../home/erik/${config.networking.hostName};
}
