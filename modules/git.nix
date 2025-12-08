{ pkgs, ... }:

{
  # 1. GIT CONFIGURATION
  programs.git = {
    enable = true;
    userName = "sdm06";
    userEmail = "diachuksviatoslav@gmail.com";
    
    # Enable 'delta' (syntax highlighting for git diffs)
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };
    };

    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
      
      # Use SSH for GitHub automatically
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
    };

    # Useful Aliases
    aliases = {
      co = "checkout";
      c = "commit";
      s = "status";
      br = "branch";
      st = "status";
    };
  };

  # 2. GITHUB CLI TOOL
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
