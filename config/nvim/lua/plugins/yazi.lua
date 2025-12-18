return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    -- specific key to open Yazi
    { "<leader>y", "<cmd>Yazi<cr>", desc = "Open Yazi" },
  },
  opts = {
    open_for_directories = true, -- Replaces netrw for directory management
    yazi_floating_window_winblend = 0, -- Fixes transparency issues
    keymaps = {
      show_help = '<f1>',
    },
  },
}
