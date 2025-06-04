{pkgs, ...}: {
  imports = [
    ./bash
    ./btop
    ./direnv
    ./fzf
    ./gh
    ./git
    ./lazygit
    ./neovim
  ];

  home.packages = with pkgs; [
    alejandra # Nix Formatter
    bash-language-server # Bash LSP
    nh # Home manager and Nix wrapper
    nix-search-tv # Fuzzy search for NixOS packages
    nixd # Nix LSP
    prettierd # Common formatter
  ];
}
