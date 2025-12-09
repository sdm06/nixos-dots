{ config, pkgs, ... }:

{
  # 1. Enable DWM
  services.xserver.windowManager.dwm.enable = true;

  # 2. Install System Packages
  environment.systemPackages = with pkgs; [
    st
    dmenu
    dwmblocks
    # Tools needed for status bar scripts
    procps
    lm_sensors  # CPU temp
    acpi        # Battery
    sysstat     # CPU usage
    xorg.xsetroot
    brightnessctl
    pamixer
  ];

  # 3. Start dwmblocks automatically
  # We use 'sessionCommands' to ensure it runs when DWM starts
  services.xserver.displayManager.sessionCommands = ''
    # Kill any existing instance to prevent duplicates if you log out/in
    pkill dwmblocks || true
    
    # Start the status bar
    dwmblocks &
  '';

  # 4. Overlays (Compiling from local source)
  nixpkgs.overlays = [
    (self: super: {
      
      # DWM (Pure Relative Path)
      dwm = super.dwm.overrideAttrs (oldAttrs: {
        src = ../config/suckless/dwm;
      });

      # ST (Pure Relative Path)
      st = super.st.overrideAttrs (oldAttrs: {
        src = ../config/suckless/st;
      });

      # DMENU (Pure Relative Path)
      dmenu = super.dmenu.overrideAttrs (oldAttrs: {
        src = ../config/suckless/dmenu;
      });

      # DWMBLOCKS (Pure Relative Path)
      dwmblocks = super.stdenv.mkDerivation {
        name = "dwmblocks";
        src = ../config/suckless/dwmblocks;
        buildInputs = [ pkgs.xorg.libX11 ]; # Standard dependency
        installPhase = ''
          make install PREFIX=$out
        '';
      };

    })
  ];
}
