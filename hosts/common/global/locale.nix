{lib, ...}: {
  time.timeZone = lib.mkDefault "America/Chicago";
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    supportedLocales = lib.mkDefault ["en_US.UTF-8/UTF-8"];
    extraLocaleSettings = {LC_MONETARY = lib.mkDefault "en_US.UTF-8";};
  };
  console.keyMap = lib.mkDefault "us";
}
