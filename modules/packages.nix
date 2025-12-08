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
    git
    gcc             # C Compiler (Needed for Nvim Treesitter)
    nodejs          # Needed for Nvim Copilot/Lazy/servers
    azure-cli
    terraform
    rust-analyzer
  ];
}
