local M = {}

M.data = {
  lua = { lsp = "lua-language-server", formatter = "stylua" },
  python = { lsp = "pyright", formatter = "black", linter = "ruff" },
  javascript = { lsp = "typescript-language-server", formatter = "prettierd", linter = "eslint_d" },
  typescript = { lsp = "typescript-language-server", formatter = "prettierd", linter = "eslint_d" },
  rust = { lsp = "rust_analyzer", formatter = "rustfmt" },
  go = { lsp = "gopls", formatter = "gofumpt", linter = "golangci_lint" },
  markdown = { lsp = "marksman", formatter = "prettierd" },
  json = { lsp = "json-lsp", formatter = "prettierd" },
  c = { lsp = "clangd", formatter = "clang-format", linter = "clang-tidy" },
  cpp = { lsp = "clangd", formatter = "clang-format", linter = "clang-tidy" },
  sh = { lsp = "bash-language-server", formatter = "shfmt", linter = "shellcheck" },
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
  local mappings = require("mason-lspconfig.mappings").get_mason_map()
  for _, v in pairs(M.data) do
    if not servers[v.lsp] then
      local lspname = mappings.package_to_lspconfig[v.lsp]
      if lspname then
        vim.lsp.enable(lspname)
      end
    end
  end
end

M.ensure_installed = function()
  require("mason").setup({ install_root_dir = vim.fn.stdpath("config") .. "/mason" })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
      local registry = require("mason-registry")
      local ft = vim.bo[args.buf].filetype
      local spec = M.data[ft]
      if not spec then
        return
      end

      for _, tool in pairs(spec) do
        if type(tool) == "string" then
          local ok, pkg = pcall(registry.get_package, tool)
          if ok and not pkg:is_installed() then
            pkg:install()
          end
        end
      end
    end,
  })
end

return M
