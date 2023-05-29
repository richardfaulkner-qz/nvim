local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  diagnostics_format = "[#{c}] #{m} (#{s})",
  debounce = 250, -- default, if null_ls slows things down increase this
  sources = {
    -- General
    null_ls.builtins.diagnostics.codespell,

    -- Lua mostly just used for nVim
    null_ls.builtins.formatting.stylua,

    -- JS
    null_ls.builtins.diagnostics.eslint_d,

    -- Kotlin
    null_ls.builtins.diagnostics.ktlint,
    null_ls.builtins.formatting.ktlint,

    -- Python formatting
    null_ls.builtins.formatting.black,
    null_ls.builtins.diagnostics.mypy,

    -- Go
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.diagnostics.golangci_lint,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          vim.lsp.buf.format()
        end,
      })
    end
  end,
})
