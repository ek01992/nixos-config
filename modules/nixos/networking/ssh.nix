{
  lib,
  opts,
  config,
  ...
}:
{
  options.ndots.networking.ssh = lib.mkEnableOption "ssh";
  config = {
    services.openssh = {
      enable = config.ndots.networking.ssh;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
      };
    };

    users.users."${opts.username}".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPakom6FvoSpBc0nmunHQUZwQI9VtS52i4W4WLuiUMpc ek01992@proton.me"
    ];
  };
}