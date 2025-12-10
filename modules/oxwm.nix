{ config, pkgs, ... }:

let
  # Define the Rust Package
  oxwm = pkgs.rustPlatform.buildRustPackage {
    pname = "oxwm";
    version = "0.1.0";

    # Point to your local folder
    src = ../config/oxwm;

    # Rust specific: Lockfile handles dependencies
    cargoLock = {
      lockFile = ../config/oxwm/Cargo.lock;
    };

    # Compile-time tools (needed to find system libraries)
    nativeBuildInputs = [ pkgs.pkg-config ];

    # Runtime Libraries (Rust crates link against these)
    buildInputs = with pkgs.xorg; [
      libxcb
      libX11
      libXrandr
      libXinerama
      libXft
    ];
  };
in
{
  # 1. Install oxwm to system
  environment.systemPackages = [ oxwm ];

  # 2. Register the Session for Ly
  services.xserver.windowManager.session = [{
    name = "oxwm";
    start = ''
      # Load Scaling
      ${pkgs.xorg.xrdb}/bin/xrdb -merge $HOME/.Xresources
      
      # Start OXWM
      ${oxwm}/bin/oxwm
    '';
  }];
}
