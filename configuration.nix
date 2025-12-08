{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.allowUnfree = true;

  hardware.facetimehd.enable = true;
  
  # --- MACBOOK HARDWARE OPTIMIZATIONS ---
  
  # 1. Keyboard/Touchpad Driver tweaks
  boot.kernelModules = [ "hid_apple" ];
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';

  # 2. Kernel Params for Power & Brightness
  boot.kernelParams = [ 
    "acpi_osi=Linux" 
    "acpi_backlight=video" 
    "button.lid_init_state=open"
  ];

  # 3. Fan Control (Essential for MacBooks)
  services.mbpfan = {
    enable = true;
    aggressive = false; 
    settings.general = {
      low_temp = 50;
      high_temp = 55;
      max_temp = 65;
    };
  };

  # 4. Keyboard Wake-up Fix
  powerManagement.enable = true;
  powerManagement.resumeCommands = ''
    ${pkgs.kmod}/bin/rmmod atkbd
    ${pkgs.kmod}/bin/modprobe atkbd reset=1
  '';

  # 5. NVMe d3cold Fix (Prevents crash on sleep)
  systemd.services.disable-nvme-d3cold = {
    enable = true;
    description = "Disable d3cold for NVMe to fix suspend issues";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "disable-d3cold" ''
        if [ -f /sys/bus/pci/devices/0000:01:00.0/d3cold_allowed ]; then
          echo 0 > /sys/bus/pci/devices/0000:01:00.0/d3cold_allowed
        fi
      '';
    };
  };

  networking.hostName = "sdnixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  services.displayManager.ly.enable = true;
  
  services.xserver = {
    enable = true;
    autoRepeatDelay = 400;
    autoRepeatInterval = 35;
    windowManager.qtile.enable = true;
  };
    
  services.libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        disableWhileTyping = true;
      };
  };

  virtualisation.docker.enable = true;

  services.picom.enable = true;

  # --- POWER MANAGEMENT ---
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=30m
    '';
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
  '';

  # --- SPURIOUS WAKEUP FIX ---
  systemd.services.fix-macbook-wakeup = {
    enable = true;
    description = "Disable spurious wakeups on MacBook";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "fix-wakeup" ''
        grep -q "XHC1.*enabled" /proc/acpi/wakeup && echo XHC1 > /proc/acpi/wakeup || true
        grep -q "LID0.*enabled" /proc/acpi/wakeup && echo LID0 > /proc/acpi/wakeup || true
      '';
    };
  };

  # --- LOCKING (SLOCK) ---

  programs.slock.enable = true;

  nixpkgs.overlays = [
    (self: super: {
      slock = super.slock.overrideAttrs (oldAttrs: {
        postPatch = ''
          sed -i '/chmod/d' Makefile
        '';
        configFile = ./config/slock/config.h;
        preConfigure = ''
          cp $configFile config.def.h
        '';
      });
    })
  ];

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.slock}/bin/slock";
  };

  users.users.sdmnix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    alacritty
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";
}
