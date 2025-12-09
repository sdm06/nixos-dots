{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory symlinks
  configs = {
    qtile = "qtile";
    nvim = "nvim";
    rofi = "rofi";
    alacritty = "alacritty";
    picom = "picom";
    btop = "btop";
  };
in

{
  # --- IMPORTS ---
  imports = [
    ./modules/packages.nix
    ./modules/nvim.nix
    ./modules/bash.nix
    ./modules/tmux.nix
    ./modules/git.nix
    ./modules/azure.nix
  ];

  # --- USER INFO ---
  home.username = "sdmnix";
  home.homeDirectory = "/home/sdmnix";
  home.stateVersion = "25.05";
  programs.git.enable = true;

  # --- NOTIFICATIONS (DUNST) ---
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#7aa2f7";
        font = "JetBrainsMono Nerd Font 10";
      };
      urgency_normal = {
        background = "#1a1b26";
        foreground = "#a9b1d6";
        timeout = 10;
      };
    };
  };

  # --- DOTFILES LINKING (XDG) ---
  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  # --- VIM LEGACY LINKING (.vimrc) ---
  # Links ~/.vim folder
  home.file.".vim" = {
    source = create_symlink "${dotfiles}/vim";
    recursive = true;
  };
  # Links ~/.vimrc file
  home.file.".vimrc".source = create_symlink "${dotfiles}/vim/vimrc";

  # --- ENVIRONMENT VARIABLES ---
  home.sessionVariables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5"; 
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    XCURSOR_SIZE = "40";
  };
  xresources.properties = {
    "Xft.dpi" = 144;  # Try 120 or 144 for MacBook screens
    "Xft.autohint" = 0;
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
  };
  
  # --- CURSOR THEME ---
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 40;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  # --- PATH ---
  # Adds your scripts folder to the system path
  home.sessionPath = [
    "$HOME/nixos-dotfiles/scripts"
  ];
}
