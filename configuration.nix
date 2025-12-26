{ config, lib, pkgs, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # --- Boot Loader ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # --- MacBook Keyboard Fix ---
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2 iso_layout=0
  '';

  nixpkgs.config.allowUnfree = true;

  # --- Hardware Support ---
  hardware.facetimehd.enable = true;
  hardware.graphics.enable = true; 
  programs.dconf.enable = true;
  services.pipewire.enable = true;

  # --- Bluetooth ---
  hardware.bluetooth.enable = true; 
  hardware.bluetooth.powerOnBoot = true;

  # --- Power Management ---
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    extraConfig = ''
      HandlePowerKey=suspend
      HandleLidSwitch=suspend
      HandleLidSwitchExternalPower=suspend
      IdleAction=suspend
      IdleActionSec=30m
    '';
  };

  networking.networkmanager.wifi.powersave = false;

  # --- Networking ---
  networking.hostName = "sdnixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Warsaw";

  xdg.portal = {
  enable = true;
  wlr.enable = true;
  # GTK portal is needed for the "Select Screen" menu to appear
  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  
  # CRITICAL: Force 'wlr' for screen sharing. 
  # Without this, it defaults to 'gtk' which cannot record Sway screens.
  config = {
    common = {
      default = [ "wlr" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ]; # Optional, keeps logins saved
    };
  };
};
# Ensure DBus is working correctly
  services.dbus.enable = true;

  # --- Display Manager ---
  services.displayManager.ly = {
    enable = true;
    settings = { animation = "matrix"; save = true; };
  };

  # --- Sway ---
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # --- Security & Permissions ---
  security.polkit.enable = true;
  
  # --- SwayOSD Setup ---
  services.udev.packages = with pkgs; [ swayosd ];

  security.pam.services.swaylock = {};
  
  # --- Virtualisation ---
  virtualisation.docker.enable = true;

  # --- Adblock ---
  networking.extraHosts =
    let
      hostsPath = "https://raw.githubusercontent.com/stevenblack/hosts/master/hosts";
      hostsFile = pkgs.fetchurl {
        url = hostsPath;
        sha256 = "sha256-j0lJ+v2ICBOkL/1E06vkU1jyCFU7kcLDUPY/DYexVpo=";
      };
    in builtins.readFile hostsFile; 

  # --- Users ---
  users.users.sdmnix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" "docker" "video" ];
  };

  # --- System Packages ---
  environment.systemPackages = with pkgs; [
    vim wget git foot swayosd brightnessctl papirus-icon-theme
  ];

  # --- Fonts ---
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";
}
