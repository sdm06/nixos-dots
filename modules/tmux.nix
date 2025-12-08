{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.bash}/bin/bash";
    terminal = "tmux-256color";
    historyLimit = 100000;
    
    extraConfig = builtins.readFile ../config/tmux/tmux.conf;
  };
}
