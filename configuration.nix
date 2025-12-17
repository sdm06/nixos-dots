{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.allowUnfree = true;

  # --- HARDWARE SUPPORT ---
  hardware.facetimehd.enable = true;
  hardware.graphics.enable = true; 

  # --- POWER MANAGEMENT ---
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    extraConfig = ''
      HandlePowerKey=suspend
      HandleLidSwitch=suspend
      HandleLidSwitchExternalPower=suspend
      HybridSleepState=suspend
      IdleAction=suspend
      IdleActionSec=30m
    '';
  };

  # Fix WiFi crashing on wake
  networking.networkmanager.wifi.powersave = false;

  # Standard Networking & Time
  networking.hostName = "sdnixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Warsaw";

  # --- LOGIN MANAGER (Ly) ---
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      hide_borders = false;
      save = true;
    };
  };

  # --- WINDOW MANAGER: SWAY ---
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Required for Sway to access hardware and show dialogs
  security.polkit.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable PAM for swaylock (so it accepts your password)
  security.pam.services.swaylock = {};

  # --- VIRTUALISATION ---
  virtualisation.docker.enable = true;

  # --- ADBLOCK ---
  networking.extraHosts =
    let
      hostsPath = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
      hostsFile = pkgs.fetchurl {
        url = hostsPath;
        sha256 = "sha256-cGioMzR4N7bemQDf/+yvumevMD/w8nYBhNy1T+zB8PI=";
      };
    in builtins.readFile hostsFile; 

  # --- USERS ---
  users.users.sdmnix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" ];
    packages = with pkgs; [ tree ];
  };

  # --- SYSTEM PACKAGES ---
  environment.systemPackages = with pkgs; [
    vim
    wget
    git 
    foot
  ];

  # --- FONTS ---
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";
}
