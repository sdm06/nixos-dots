{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/suckless.nix
      ./modules/oxwm.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.allowUnfree = true;

  # Hardware Support
  hardware.facetimehd.enable = true;
  hardware.graphics.enable = true; 

  # --- POWER MANAGEMENT  ---
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

  # Login Manager 
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      hide_borders = false;
      save = true;
    };
  };

  # Adblock
  networking.extraHosts =
    let
      hostsPath = https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts;
      hostsFile = pkgs.fetchurl {
        url = hostsPath;
        sha256 = "sha256-cGioMzR4N7bemQDf/+yvumevMD/w8nYBhNy1T+zB8PI=";
      };
  in builtins.readFile hostsFile; 

  # Window Manager & Input
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    windowManager.qtile.enable = true;
  };
    
  services.libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = false;
        disableWhileTyping = true;
      };
  };

  virtualisation.docker.enable = true;
  services.picom.enable = true;

  # Screen Locking
  programs.slock.enable = true;
  nixpkgs.overlays = [
    (self: super: {
      slock = super.slock.overrideAttrs (oldAttrs: {
        postPatch = ''
          sed -i '/chmod/d' Makefile
        '';
        # Assuming you have this file, otherwise comment the next 3 lines out
        # configFile = ./config/slock/config.h;
        # preConfigure = ''
        #   cp $configFile config.def.h
        # '';
      });
    })
  ];

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.slock}/bin/slock";
  };

  # Users & Packages
  users.users.sdmnix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    packages = with pkgs; [ tree ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim wget git alacritty
    zed-editor
    #inputs.zen-browser.packages."${pkgs.system}".specific
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";
}
