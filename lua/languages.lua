local M = {}

M.data = {
  lua = { lang_server = "lua-language-server", formatter = "stylua" },
  python = { lang_server = "pyright", formatter = "black", linter = "ruff" },
  javascript = { lang_server = "typescript-language-server", formatter = "prettierd", linter = "eslint_d" },
  typescript = { lang_server = "typescript-language-server", formatter = "prettierd", linter = "eslint_d" },
  rust = { lang_server = "rust_analyzer", formatter = "rustfmt" },
  go = { lang_server = "gopls", formatter = "gofumpt", linter = "golangci_lint" },
  markdown = { lang_server = "marksman", formatter = "prettierd" },
  json = { lang_server = "json-lsp", formatter = "prettierd" },
  c = { lang_server = "clangd", formatter = "clang-format", linter = "clang-tidy" },
  cpp = { lang_server = "clangd", formatter = "clang-format", linter = "clang-tidy" },
  sh = { lang_server = "bash-language-server", formatter = "shfmt", linter = "shellcheck" },
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
  local pkg2lsp = mappings.package_to_lspconfig
  for _, v in pairs(M.data) do
    if not servers[v.lang_server] then
      local lspname = pkg2lsp[v.lang_server]
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

      local install = function(name)
        local ok, pkg = pcall(registry.get_package, name)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end

      for _, tool in pairs(spec) do
        if type(tool) == "string" then
          install(tool)
        end
      end
    end,
  })
end

return M
