{config, ...}: {
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      pager = "less";
    };
  };
  home.persistence = {
    "/persist/${config.home.homeDirectory}".directories = [".config/gh"];
  };
}
