{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- GUI & Desktop ---
    librewolf
    

    # --- Sway Essentials ---
    swaylock          # Lock screen
    slurp
    xdg-desktop-portal-wlr
    swayidle          # Auto-lock logic
    wl-clipboard      # Clipboard (wl-copy, wl-paste)
    cliphist          # <--- ADDED: Required for clipboard history
    grim              # Screenshot tool
    slurp             # Screenshot area selector
    mako              # Notification daemon
    i3status
    wofi
    
    # --- System Utilities ---
    htop
    btop              # Process monitor
    upower            # Battery info
    libnotify         # Notification sender
    brightnessctl     # Brightness control
    pamixer           # Volume control
    nitch             # System fetch tool
    eza               # Better 'ls'
    pulsemixer
    bluetuith

    # --- CLI Tools ---
    ripgrep           # Fast grep
    fd                # Fast find
    fzf               # Fuzzy finder
    tree
    psmisc
    ffmpegthumbnailer  # Video thumbnails
    imagemagick        # Image thumbnails
    poppler            # PDF thumbnails
    jq                 # JSON previews
    zoxide
    starship
    
    # --- Development & Cloud ---
    gcc               # C Compiler
    cargo
    rustc
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
  ];
}
