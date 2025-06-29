local M = {}

M.data = {
  lua = { lsp = "lua_ls", formatter = "stylua" },
  python = { lsp = "pyright", formatter = "black", linter = "ruff" },
  javascript = { lsp = "tsserver", formatter = "prettier", linter = "eslint_d" },
  typescript = { lsp = "tsserver", formatter = "prettier", linter = "eslint_d" },
  rust = { lsp = "rust_analyzer", formatter = "rustfmt" },
  go = { lsp = "gopls", formatter = "gofumpt", linter = "golangci_lint" },
  markdown = { lsp = "marksman", formatter = "prettier" },
  json = { lsp = "jsonls", formatter = "prettier" },
  c = { lsp = "clangd", formatter = "clang-format", linter = "clang-tidy" },
  cpp = { lsp = "clangd", formatter = "clang-format", linter = "clang-tidy" },
}

M.for_conform = function()
  local c = {}
  for k, v in pairs(M.data) do
    c[k] = { v.formatter }
  end
  return c
end

M.enable_all_servers = function()
  local servers = {}
  for _, v in pairs(M.data) do
    if not servers[v.lsp] then
      vim.lsp.enable(v.lsp)
    end
  end
end

return M
