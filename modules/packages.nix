{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- GUI & Desktop ---
    rofi
    xwallpaper
    picom
    pavucontrol

    # --- System Utilities ---
    btop            # Process monitor
    upower          # Battery info
    libnotify       # Notifications
    xclip           # Clipboard engine
    brightnessctl   # Brightness control
    pamixer         # Volume control
    maim            # Screenshots
    haskellPackages.greenclip # Clipboard manager
    nitch
    eza

    # --- CLI Tools ---
    ripgrep         # Fast grep (needed by Nvim too, but useful generally)
    fd              # Fast find (needed by Nvim too)
    fzf             # Fuzzy finder
    tree
    
    # --- Development & Cloud ---
    gcc             # C Compiler (Needed for Nvim Treesitter)
    docker
    docker-compose
    lazydocker
    lazygit
    nodejs          # Needed for Nvim Copilot/Lazy/servers
    terraform
    rust-analyzer
  ];
}
