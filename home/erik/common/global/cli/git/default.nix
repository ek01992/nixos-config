{config, ...}: {
  programs.git = {
    enable = true;
    userName = "ek01992";
    userEmail = "ek01992@proton.me";
    includes = [{path = "~/.git/extra-config";}];
    aliases = {co = "checkout";};

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      merge.conflictstyle = "diff3";
      branch.sort = "-committerdate";
      core = {
        editor = "nvim";
        pager = "less";
      };
      lfs.enable = true;
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
    };

    ignores = [
      ### Nix ###
      ".direnv"
      "result*"

      ### Linux ###
      "*~"

      # temporary files which can be created if a process still has a handle open of a deleted file
      ".fuse_hidden*"

      # KDE directory preferences
      ".directory"

      # Linux trash folder which might appear on any partition or disk
      ".Trash-*"

      # .nfs files are created when an open file is removed but is still being accessed
      ".nfs*"

      ### macOS ###
      # General
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"

      # Icon must end with two \r
      "Icon"

      # Thumbnails
      "._*"

      # Files that might appear in the root of a volume
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"

      # Directories potentially created on remote AFP share
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"

      ### Windows ###
      # Windows thumbnail cache files
      "Thumbs.db"
      "Thumbs.db:encryptable"
      "ehthumbs.db"
      "ehthumbs_vista.db"

      # Dump file
      "*.stackdump"

      # Folder config file
      "[Dd]esktop.ini"

      # Recycle Bin used on file shares
      "$RECYCLE.BIN/"

      # Windows Installer files
      "*.cab"
      "*.msi"
      "*.msix"
      "*.msm"
      "*.msp"

      # Windows shortcuts
      "*.lnk"

      ### Vim ###
      # Swap
      "[._]*.s[a-v][a-z]"
      "!*.svg" # comment out if you don't need vector files
      "[._]*.sw[a-p]"
      "[._]s[a-rt-v][a-z]"
      "[._]ss[a-gi-z]"
      "[._]sw[a-p]"

      # Session
      "Session.vim"
      "Sessionx.vim"

      # Temporary
      ".netrwhist"
      "*~"

      # Auto-generated tag files
      "tags"

      # Persistent undo
      "[._]*.un~"
    ];
  };
}
