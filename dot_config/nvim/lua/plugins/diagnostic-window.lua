return {
  {
    "cseickel/diagnostic-window.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = { "DiagWindowShow", "DiagWindowHide" }, -- lazy-load on command
    -- Optionally, you can add a keymap:
    keys = {
      {
        "<leader>dw",
        "<cmd>DiagWindowShow<cr>",
        desc = "Show Diagnostic Window",
      },
    },
  },
}
