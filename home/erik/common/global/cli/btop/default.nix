{config, ...}: {
  programs = {
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
        update_ms = 2000;
        proc_sorting = "cpu";
        proc_tree = true;
      };
    };
  };
}