return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "arkav/lualine-lsp-progress",
  },
  opts = function(_, opts)
    -- Define your colors
    local colors = {
      yellow = "#ECBE7B",
      cyan = "#008080",
      darkblue = "#081633",
      green = "#98be65",
      orange = "#FF8800",
      violet = "#a9a1e1",
      magenta = "#c678dd",
      blue = "#51afef",
      red = "#ec5f67",
    }

    -- Replace lualine_c with your custom config
    opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
      theme = "gruvbox",
    })
    opts.sections.lualine_c = {
      {
        "lsp_progress",
        display_components = {
          "lsp_client_name",
          "spinner",
          { "title", "percentage", "message" },
        },
        colors = {
          percentage = colors.cyan,
          title = colors.cyan,
          message = colors.cyan,
          spinner = colors.cyan,
          lsp_client_name = colors.magenta,
          use = true,
        },
        separators = {
          component = " ",
          progress = " | ",
          percentage = { pre = "", post = "%% " },
          title = { pre = "", post = ": " },
          lsp_client_name = { pre = "[", post = "]" },
          spinner = { pre = "", post = "" },
          message = { pre = "(", post = ")", commenced = "In Progress", completed = "Completed" },
        },
        timer = {
          progress_enddelay = 500,
          spinner = 1000,
          lsp_client_name_enddelay = 1000,
        },
        spinner_symbols = {
          "🌑 ",
          "🌒 ",
          "🌓 ",
          "🌔 ",
          "🌕 ",
          "🌖 ",
          "🌗 ",
          "🌘 ",
        },
      },
    }

    -- You can add more components to lualine_c if you want, e.g.:
    -- table.insert(opts.sections.lualine_c, "filename")

    return opts
  end,
}
