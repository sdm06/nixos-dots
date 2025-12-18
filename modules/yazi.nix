{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    # Keep RAR support
    package = pkgs.yazi.override {
      _7zz = pkgs._7zz-rar;
    };

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "mtime";
        sort_dir_first = true;
        sort_reverse = true;
        ratio = [ 1 4 3 ];
      };
      
      # --- SIXEL SUPPORT (For Foot) ---
      preview = {
        image_filter = "lanczos3";
        image_quality = 90;
        sixel_fraction = 15;
      };
    };

    # Keymaps
    keymap = {
      manager = {
        prepend_keymap = [
          { on = [ "T" ]; run = "shell '$SHELL' --block --confirm"; desc = "Open terminal here"; }
        ];
      };
    };

    theme = {
      manager = {
        preview_hovered = { fg = "yellow"; };
      };
    };
  };
}

