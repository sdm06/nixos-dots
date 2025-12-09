{ config, pkgs, ... }:

let
  # 1. Define the OXWM Package
  # This tells Nix how to compile the code from your config folder
  oxwm = pkgs.stdenv.mkDerivation {
    name = "oxwm";
    version = "0.1";
    
    # Point to your local folder (Pure Relative Path)
    src = ../config/oxwm;

    # Dependencies (Standard X11 libraries)
    buildInputs = with pkgs.xorg; [
      libX11
      libXft
      libXinerama
      libXrandr
      libxcb
    ];

    # Installation logic
    # We force the destination to be the Nix store output ($out)
    installPhase = ''
      mkdir -p $out/bin
      make install PREFIX=$out
    '';
  };
in
{
  # 2. Install it to System Packages
  environment.systemPackages = [ oxwm ];

  # 3. Register as a Window Manager Session
  # This makes "oxwm" appear in your Ly login screen
  services.xserver.windowManager.session = [{
    name = "oxwm";
    start = ''
      # 1. Load Xresources (Scaling)
      ${pkgs.xorg.xrdb}/bin/xrdb -merge $HOME/.Xresources

      # 4. Start the Window Manager
      ${oxwm}/bin/oxwm
    '';
  }];
}
