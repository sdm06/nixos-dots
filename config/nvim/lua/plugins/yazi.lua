return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>y", "<cmd>Yazi<cr>", desc = "Open Yazi" },
  },
  opts = {
    -- Enable opening directories with Yazi automatically
    open_for_directories = true,
    
    -- Optional: Fix transparency issues if you use a transparent background
    yazi_floating_window_winblend = 0,

    keymaps = {
      show_help = '<f1>',
    },
  },
}
