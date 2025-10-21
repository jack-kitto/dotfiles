return {
  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    opts = {},
    keys = {
      -- Show Pretty Hover (e.g. <leader>k)
      {
        "<leader>k",
        function()
          require("pretty_hover").hover()
        end,
        desc = "Pretty Hover",
        mode = { "n" },
      },
      -- Close Pretty Hover (e.g. <leader>K)
      {
        "<leader>K",
        function()
          require("pretty_hover").close()
        end,
        desc = "Close Pretty Hover",
        mode = { "n" },
      },
    },
  },
}
