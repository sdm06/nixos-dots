{ config, pkgs, ... }:

# 1. DEFINE SCRIPTS
let
  surf_open = pkgs.writeShellScriptBin "surf-open" ''
    #!/bin/sh
    query=$(echo "" | ${pkgs.dmenu}/bin/dmenu -p "Search:" -fn "JetBrainsMono Nerd Font Mono-14" -nb "#1a1b26" -nf "#a9b1d6" -sb "#7aa2f7" -sf "#1a1b26" -w "$1")
    [ -z "$query" ] && exit 0
    if echo "$query" | grep -E '^[a-zA-Z]+://' >/dev/null; then echo "$query";
    elif echo "$query" | grep -E '^[a-zA-Z0-9.-]+\.[a-z]{2,}' >/dev/null; then echo "http://$query";
    else echo "https://duckduckgo.com/?q=$query"; fi
  '';

  surftab = pkgs.writeShellScriptBin "surftab" ''
    #!/bin/sh
    
    # Environment Fixes for White Screen
    export LIBGL_ALWAYS_SOFTWARE=1
    export WEBKIT_DISABLE_COMPOSITING_MODE=1
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
    export WEBKIT_FORCE_SANDBOX=0
    export GDK_BACKEND=x11

    # Default to DuckDuckGo if no URL is provided
    # The empty quotes "" tell surf to expect an XID from tabbed
    target="''${1:-https://duckduckgo.com}"
    exec tabbed -c -r 2 surf -e "" "$target"
  '';
in

# 2. MAIN CONFIGURATION
{
  services.xserver.windowManager.dwm.enable = true;

  environment.systemPackages = with pkgs; [
    st
    dmenu
    dwmblocks
    
    surf
    tabbed
    surf_open
    surftab
    xorg.xprop
    
    lm_sensors
    acpi
    procps
    sysstat
    xorg.xsetroot
    brightnessctl
    pamixer
    
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];

  services.xserver.displayManager.sessionCommands = ''
    pkill dwmblocks || true
    dwmblocks &
  '';

  nixpkgs.overlays = [
    (self: super: {
      
      dwm = super.dwm.overrideAttrs (oldAttrs: { src = ../config/suckless/dwm; });
      st = super.st.overrideAttrs (oldAttrs: { src = ../config/suckless/st; });
      dmenu = super.dmenu.overrideAttrs (oldAttrs: { src = ../config/suckless/dmenu; });
      
      dwmblocks = super.stdenv.mkDerivation {
        name = "dwmblocks";
        src = ../config/suckless/dwmblocks;
        buildInputs = [ pkgs.xorg.libX11 ]; 
        installPhase = ''
          mkdir -p $out/bin
          make install PREFIX=$out
        '';
      };

      tabbed = super.tabbed.overrideAttrs (oldAttrs: {
        src = ../config/suckless/tabbed;
        buildInputs = [ pkgs.xorg.libX11 pkgs.xorg.libXft ];
      });

      surf = super.surf.overrideAttrs (oldAttrs: {
        src = ../config/suckless/surf;
        
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ 
          pkgs.makeWrapper 
          pkgs.wrapGAppsHook 
        ];
        
        buildInputs = oldAttrs.buildInputs ++ [ 
          pkgs.gcr 
          pkgs.glib-networking 
          pkgs.webkitgtk_4_1
        ];

        patches = []; 
      });

    })
  ];
}
