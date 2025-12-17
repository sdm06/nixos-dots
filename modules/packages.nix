{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- GUI & Desktop ---
    pavucontrol       # Volume Control GUI
    librewolf

    # --- Sway Essentials ---
    swaylock          # Lock screen
    swayidle          # Auto-lock logic
    wl-clipboard      # Clipboard (wl-copy, wl-paste)
    grim              # Screenshot tool
    slurp             # Screenshot area selector
    mako              # Notification daemon
    i3status-rust
    
    # --- System Utilities ---
    btop              # Process monitor
    upower            # Battery info
    libnotify         # Notification sender
    brightnessctl     # Brightness control (Moved from System)
    pamixer           # Volume control (Moved from System)
    nitch             # System fetch tool
    eza               # Better 'ls'

    # --- CLI Tools ---
    ripgrep           # Fast grep
    fd                # Fast find
    fzf               # Fuzzy finder
    tree
    
    # --- Development & Cloud ---
    gcc               # C Compiler
    gdb
    openssl
    gnumake
    docker
    docker-compose
    lazydocker
    lazygit
    nodejs
    terraform
    rust-analyzer

    # --- X11 / Unused (Commented Out) ---
    # rofi
    # xwallpaper
    # picom
    # xclip
    # maim
    # haskellPackages.greenclip
  ];
}
