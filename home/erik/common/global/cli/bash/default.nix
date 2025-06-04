{pkgs, ...}: {
  programs.bash = {
    enable = true;
    historyControl = ["erasedups" "ignorespace"];
    historyFile = "$HOME/.local/state/bash/history";

    shellAliases = {
      "?" = "duck";
      "cd.." = "cd ..";
      ls = "ls -lah --color";
      chmox = "chmod +x";
      temp = "cd $(mktemp -d)";
      ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
    };
  };
}
