{ pkgs, ... }:

{
  # 1. ENABLE DIRENV (Replaces the 'eval' hook)
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # 2. ENABLE FZF (Replaces manual sourcing if you had it)
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    # --- ALIASES ---
    shellAliases = {
      # ls / eza replacements
      ls = "eza -l --icons";
      la = "eza -a --icons";
      ll = "eza -la --icons";
      lo = "ll --sort=modified";

      # nixos stuff
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#sdnixos";
      nc = "vim ~/nixos-dotfiles/.";
      nh = "vim ~/nixos-dotfiles/home.nix";
      np = "vim ~/nixos-dotfiles/modules/packages.nix";
      nclean = "sudo nix-collect-garbage --delete-older-than 3d && nix-store --optimise";

      # oxwm stuff
      #asdf = "cd ~/repos/oxwm; nix develop";
      az-iot = "docker run --rm -it -v $HOME/.azure:/root/.azure -v \"$(pwd):/data\" -w /data mcr.microsoft.com/azure-cli";
      
      # navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      "......." = "cd ../../../../../..";
      "........" = "cd ../../../../../../..";
      "........." = "cd ../../../../../../../..";
      "..........." = "cd ../../../../../../../../..";
      
      # utils
      grep = "grep --color=auto";
      zt = "zig test";
    };


    # --- ENV VARS & CUSTOM COMMANDS ---
initExtra = ''
      export PATH="$HOME/.emacs.d/bin:$PATH"
      export MANPAGER="nvim +Man!"
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'

      # Source private aliases if they exist
      if [ -f ~/.bashrc.local ]; then
          source ~/.bashrc.local
      fi

      # Custom PS1 Prompt
      export PS1="\[\e[38;5;75m\]\u@\h \[\e[38;5;113m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"

      # --- ROBUST TMUX AUTO-START ---
#     if [[ $- == *i* ]]; then
#        # 2. Check if we are NOT already in tmux
#        if [[ -z "$TMUX" ]]; then
#        # 3. Check if we are NOT in a specific IDE terminal (VS Code, IntelliJ, etc.)
#         if [[ "$TERM_PROGRAM" != "vscode" ]] && [[ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]]; then
#           # 4. Create a NEW independent session for this window
#           exec tmux new-session
#         fi
#        fi
#       fi
#     # Run system fetch (Only runs inside the tmux pane or non-tmux shells)
      nitch
    '';  };

}
