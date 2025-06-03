{
  pkgs,
  config,
  ...
}: {

  home.packages = with pkgs; [
    fd
    ripgrep
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };

  home.persistence = {
    "/persist/${config.home.homeDirectory}".directories = [
      ".config/nvim"
      ".local/share/nvim"
      ".local/state/nvim"
    ];
  };
}