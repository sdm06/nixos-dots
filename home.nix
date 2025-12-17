{ config, pkgs, ... }:

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

  # --- DOTFILES LINKING (XDG) ---
  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  # --- VIM LEGACY LINKING (.vimrc) ---
  home.file.".vim" = {
    source = create_symlink "${dotfiles}/vim";
    recursive = true;
  };
  home.file.".vimrc".source = create_symlink "${dotfiles}/vim/vimrc";

  # --- ENVIRONMENT VARIABLES (Scaling Fix) ---
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # --- CURSOR THEME ---
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 32; # Bumped slightly for HiDPI
    gtk.enable = true;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  # --- PATH ---
  home.sessionPath = [
    "$HOME/nixos-dotfiles/scripts"
  ];
}
