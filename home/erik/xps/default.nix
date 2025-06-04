{lib, ...}: {
  imports = [../common/global];

  home.stateVersion = lib.mkDefault "25.11";
}