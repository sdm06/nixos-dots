{ pkgs, ... }:

{
  # --- 1. SET EDITOR ENV VARS ---
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # --- 2. SHELL ALIASES ---
  # Since we are not using programs.neovim, we add aliases manually
  home.shellAliases = {
#   vi = "nvim";
#   vim = "nvim";
  };

  # --- 3. PACKAGES ---
  home.packages = with pkgs; [
    # Search & Tools
    ripgrep
    fd
    fzf
    gcc
    nodejs

    # LSPs & Formatters
    lua-language-server
    nil
    nixpkgs-fmt

    # Image Support: Binary Tools
    imagemagick
    ueberzugpp 

    # --- THE MAGIC PART ---
    # We install Neovim as a package, NOT a program module.
    # We "override" it to inject the Magick Lua library.
    # This gives you the dependency without touching your config files.
    (neovim.override {
      extraLuaPackages = ps: [ ps.magick ];
    })
  ];

  # DISABLE the module so it doesn't try to write init.lua
  programs.neovim.enable = false;
}
