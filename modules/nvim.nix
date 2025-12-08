{ pkgs, ... }:

{
  # 1. Install Neovim Dependencies (LSPs, Formatters)
  home.packages = with pkgs; [
    # Nix Support
    nil             # Nix Language Server
    nixpkgs-fmt     # Nix Formatter

    # Lua Support (for editing your nvim config)
    lua-language-server
    stylua

    # Terraform / IaC Support
    terraform-ls
    tflint
  ];

  # 2. Enable Neovim
  programs.neovim = {
    enable = true;
#   viAlias = true;
#   vimAlias = true;
    defaultEditor = true;

    # We leave 'plugins' empty so you can use lazy.nvim 
    # to manage them inside your ~/.config/nvim/init.lua
  };
}
