{ config, pkgs, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory symlinks
  configs = {
    nvim = "nvim";
    sway = "sway";
    wofi = "wofi";
    btop = "btop";
    foot = "foot";
    i3status = "i3status";
  };

  # --- TOKYO NIGHT MINIMALIST CSS ---
  tokyonight-osd-style = ''
    window#osd {
      background-color: rgba(26, 27, 38, 0.90);
      border: 1px solid rgba(122, 162, 247, 0.6);
      border-radius: 99px; /* Pill shape */
    }
    #container {
      padding: 18px 24px;
    }
    image {
      color: #7aa2f7;
      min-width: 32px;
      min-height: 32px;
      margin-right: 12px;
    }
    progressbar, progress, trough {
      min-width: 180px;
      min-height: 6px;
      border-radius: 3px;
      background-color: #292e42;
      border: none;
    }
    highlight {
      background-color: #7aa2f7;
      border-radius: 3px;
    }
  '';
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
    ./modules/yazi.nix
  ];

  # --- USER INFO ---
  home.username = "sdmnix";
  home.homeDirectory = "/home/sdmnix";
  home.stateVersion = "25.05";
  programs.git.enable = true;

  # --- PACKAGES ---
  home.packages = with pkgs; [
    papirus-icon-theme
    tokyo-night-gtk
    swayosd
  ];

  # --- GTK THEME CONFIGURATION ---
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "TokyoNight-Storm";
      package = pkgs.tokyo-night-gtk;
    };
  };

  # --- DOTFILES & CONFIG LINKING (FIXED) ---
  # We merge the symlinks map with the manual CSS file entry
  xdg.configFile = (builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs) // {
      # This adds the SwayOSD style to the config set
      "swayosd/style.css".text = tokyonight-osd-style;
    };

  # --- VIM LEGACY LINKING (.vimrc) ---
  home.file.".vim" = {
    source = create_symlink "${dotfiles}/vim";
    recursive = true;
  };
  home.file.".vimrc".source = create_symlink "${dotfiles}/vim/vimrc";

  # --- ENVIRONMENT VARIABLES ---
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    GTK_THEME = "TokyoNight-Storm";
  };

  # --- CURSOR THEME ---
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 32; 
    gtk.enable = true;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  # --- XDG DESKTOP ENTRIES ---
  xdg.desktopEntries = {
    btop = {
      name = "btop";
      genericName = "System Monitor";
      exec = "foot -e btop";
      icon = "btop";
      terminal = false;
      categories = [ "System" "Monitor" "ConsoleOnly" ];
    };
    htop = {
      name = "htop";
      genericName = "Process Viewer";
      exec = "foot -e htop";
      icon = "htop";
      terminal = false;
      categories = [ "System" "Monitor" "ConsoleOnly" ];
    };
    pulsemixer = {
      name = "PulseMixer";
      genericName = "Audio Mixer";
      exec = "foot -e pulsemixer";
      terminal = false;
      icon = "audio-volume-high";
      categories = [ "AudioVideo" "Audio" "ConsoleOnly" ];
    };
    bluetuith = {
      name = "Bluetooth Menu";
      genericName = "Bluetooth Manager";
      exec = "foot -e bluetuith";
      terminal = false;
      icon = "bluetooth";
      categories = [ "System" "Settings" "ConsoleOnly" ];
    };
  };

  # --- PATH ---
  home.sessionPath = [
    "$HOME/nixos-dotfiles/scripts"
  ];
}
