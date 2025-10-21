local lspconfig = require("lspconfig")

lspconfig.tsserver.setup({
  handlers = {
    ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
      if result.diagnostics == nil then
        return
      end

      -- Format TypeScript errors
      local idx = 1
      while idx <= #result.diagnostics do
        local entry = result.diagnostics[idx]
        local formatter = require("format-ts-errors")[entry.code]
        entry.message = formatter and formatter(entry.message) or entry.message

        -- Optionally filter out certain diagnostics
        if entry.code == 80001 then
          table.remove(result.diagnostics, idx)
        else
          idx = idx + 1
        end
      end

      vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    end,
  },
})

return {}
