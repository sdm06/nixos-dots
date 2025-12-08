#!/bin/sh

# 1. SETUP SCREEN (HiDPI 200% Scaling)
# The best way to get 200% is to tell X11 the DPI is high, not to scale the pixels.
# 96 DPI * 200% = 192 DPI
# This makes text and UI crisp, not blurry.
echo "Xft.dpi: 144" | xrdb -merge

# If you REALLY prefer xrandr scaling (can be blurry, but forces size):
# xrandr --output eDP-1 --scale 0.5x0.5
# OR just set the resolution lower (crisper than scaling):
# xrandr --output eDP-1 --mode 1920x1080

# 2. SET WALLPAPER
# We add a small delay to ensure Qtile is ready before setting it
sleep 1
xwallpaper --zoom ~/nixos-dotfiles/walls/nix-wallpaper-gear.png &
greenclip daemon > /dev/null 2>&1 &
dunst &

# 3. OTHER APPS (Optional)
# picom &
# nm-applet &
