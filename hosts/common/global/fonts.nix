{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      font-awesome
      nerd-fonts.noto
      nerd-fonts.hack
    ];

    fontconfig.defaultFonts = {
      serif = ["NotoSerif Nerd Font"];
      sansSerif = ["NotoSans Nerd Font"];
      monospace = ["Hack Nerd Font Mono"];
    };
  };
}
