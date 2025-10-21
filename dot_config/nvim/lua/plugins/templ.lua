return {
  -- Add treesitter support for templ
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "templ" })
      end
    end,
  },

  -- Add LSP support via templ language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        templ = {
          -- Configure the templ language server
          -- You may need to adjust the cmd based on where templ-lsp is installed
          cmd = { "templ", "lsp" },
          filetypes = { "templ" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("go.mod", ".git")(fname)
          end,
        },
      },
    },
  },

  -- Add filetype detection for templ files
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      filetype_to_parsername = {
        templ = "templ",
      },
    },
  },

  -- Set up proper formatting for templ files
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        templ = { "templ" },
      },
    },
  },

  -- Add proper highlighting and indentation
  {
    "nelsyeung/twig.vim",
    ft = { "templ" },
    init = function()
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.templ",
        callback = function()
          vim.bo.filetype = "templ"
          -- Set indentation to 2 spaces for templ files
          vim.bo.expandtab = true
          vim.bo.shiftwidth = 2
          vim.bo.tabstop = 2
        end,
      })
    end,
  },
}
