-------------------------------------------------------------------------------
--
--       filename: plugins.lua
--    description:
--        created: 2025/06/27
--         author: ticktechman
--
-------------------------------------------------------------------------------

local conf_path = vim.fn.stdpath("config")
local map = vim.keymap.set
local languages = require("languages")

-- use lazy.nvim for plugin management
local lazypath = conf_path .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local function lsp_name()
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  local names = {}
  for _, client in pairs(clients) do
    if client.name ~= "null-ls" then
      table.insert(names, "[" .. client.name .. "]")
    end
  end
  if #names == 0 then
    return ""
  end
  return "  " .. table.concat(names, ", ")
end
-------------------------------------
-- plugins
-------------------------------------
require("lazy").setup({
  -- root path for all plugins
  root = conf_path .. "/lazy",

  spec = {
    ----------------------------
    -- colors schemes
    ----------------------------
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "folke/tokyonight.nvim", lazy = false, priority = 1000 },

    ----------------------------
    -- highlight whitespace
    ----------------------------
    { "ntpeters/vim-better-whitespace", lazy = false },

    ----------------------------
    -- blankline identicator
    ----------------------------
    {
      "lukas-reineke/indent-blankline.nvim",
      lazy = false,
      main = "ibl",
      event = "User FilePost",
      config = function()
        require("ibl").setup({
          indent = { char = "┆" },
          scope = {
            enabled = false,
            show_start = true,
            show_end = false,
          },
        })
      end,
    },

    ----------------------------
    -- file browser
    ----------------------------
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        local api = require("nvim-tree.api")
        local function attach(bufnr)
          local opts = function()
            return { buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          vim.keymap.set("n", "l", api.node.open.edit, opts())
          vim.keymap.set("n", "h", api.node.navigate.parent_close, opts())
        end
        require("nvim-tree").setup({
          on_attach = attach,
        })
      end,
    },

    ----------------------------
    -- terminal
    ----------------------------
    {
      "folke/snacks.nvim",
      lazy = false,
      opts = {
        terminal = {
          win = {
            position = "bottom", -- "bottom" | "top" | "left" | "right" | "float"
            height = 0.3,
          },
        },
      },

      keys = {
        {
          "<C-/>",
          mode = { "n", "t" },
          desc = "Toggle snacks terminal",
          silent = true,
          function()
            require("snacks.terminal").toggle()
          end,
        },
      },
    },

    ----------------------------
    -- file searching
    ----------------------------
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },

    ----------------------------
    -- tagbar
    ----------------------------
    {
      "majutsushi/tagbar",
      lazy = false,
      config = function()
        vim.g.tagbar_sort = 0
      end,
    },

    ----------------------------
    -- outline(tagbar)
    ----------------------------
    {
      "simrat39/symbols-outline.nvim",
      cmd = "SymbolsOutline",
      keys = {
        { "<leader>t", "<cmd>SymbolsOutline<CR>", desc = "Toggle Symbols Outline" },
      },
      config = function()
        require("symbols-outline").setup({
          highlight_hovered_item = true,
          show_guides = true,
          auto_preview = false,
          position = "right",
          width = 20,
          show_numbers = false,
          show_relative_numbers = false,
          show_symbol_details = true,
        })
      end,
    },

    ----------------------------
    -- status line
    ----------------------------
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },

      config = function()
        require("lualine").setup({
          options = { theme = require("lualine.themes.onedark") },
          sections = {
            lualine_x = {
              "filetype",
              "lua_progress",
              { lsp_name },
            },
          },
        })
      end,
    },

    -- bufferline
    {
      "akinsho/bufferline.nvim",
      version = "*",
      lazy = false,
      dependencies = "nvim-tree/nvim-web-devicons",
      keys = {
        { "H", "<Cmd>BufferLineCyclePrev<CR>", desc = "" },
        { "L", "<Cmd>BufferLineCycleNext<CR>", desc = "" },
      },
      config = function()
        require("bufferline").setup()
      end,
    },

    ----------------------------
    -- syntax highlight: treesitter
    ----------------------------
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "lua", "vim", "bash" },
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },

          indent = {
            enable = true,
          },
        })
      end,
    },

    ----------------------------
    -- mason for language plugins
    ----------------------------
    {
      "mason-org/mason.nvim",
      opts = {
        install_root_dir = conf_path .. "/mason",
      },
      config = function()
        require("mason").setup()
      end,
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {},
      dependencies = {
        "neovim/nvim-lspconfig",
      },
      ensure_installed = {
        "clangd",
      },

      config = function()
        -- lua ls config
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local function opts(desc)
              return { buffer = args.buf, desc = "LSP " .. desc }
            end

            map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
            map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
            map("n", "gr", vim.lsp.buf.references, opts("Go to definition"))
            map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
            map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))

            map("n", "<leader>wl", function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts("List workspace folders"))

            map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
          end,
        })

        local lua_lsp_settings = {
          Lua = {
            workspace = {
              library = {
                vim.fn.expand("$VIMRUNTIME/lua"),
                conf_path .. "/lazy/lazy.nvim/lua/lazy",
                "${3rd}/luv/library",
              },
            },
          },
        }
        vim.lsp.config("lua_ls", { settings = lua_lsp_settings })
        languages.enable_all_servers()

        -- diagnostic messages config
        local x = vim.diagnostic.severity
        vim.diagnostic.config({
          virtual_text = { prefix = "" },
          signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
          underline = true,
          float = { border = "single" },
        })
      end,
    },

    ----------------------------
    -- auto format when save it
    ----------------------------
    {
      "stevearc/conform.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("conform").setup({
          formatters_by_ft = languages.for_conform(),
          format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
          },
        })
      end,
    },

    ----------------------------
    -- auto complete
    ----------------------------
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        {
          -- snippet plugin
          "L3MON4D3/LuaSnip",
          dependencies = "rafamadriz/friendly-snippets",
          opts = { history = true, updateevents = "TextChanged,TextChangedI" },
          config = function(_, opts)
            require("luasnip").config.set_config(opts)
            -- vscode format
            require("luasnip.loaders.from_vscode").load()
            require("luasnip.loaders.from_vscode").lazy_load({ paths = { conf_path .. "/snippets" } })

            -- snipmate format
            require("luasnip.loaders.from_snipmate").load()
            require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })

            -- lua format
            require("luasnip.loaders.from_lua").load()
            require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })
          end,
        },

        -- autopairing of (){}[] etc
        {
          "windwp/nvim-autopairs",
          opts = {
            fast_wrap = {},
            disable_filetype = { "TelescopePrompt", "vim" },
          },
          config = function(_, opts)
            require("nvim-autopairs").setup(opts)

            -- setup cmp for autopairs
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
          end,
        },

        -- cmp sources plugins
        {
          "saadparwaiz1/cmp_luasnip",
          "hrsh7th/cmp-nvim-lua",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
        },
      },

      config = function()
        local cmp = require("cmp")
        cmp.setup({
          completion = { completeopt = "menu,menuone" },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },

          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },

          mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),

            ["<CR>"] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }),

            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif require("luasnip").expand_or_jumpable() then
                require("luasnip").expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif require("luasnip").jumpable(-1) then
                require("luasnip").jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          },

          sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "nvim_lua" },
            { name = "path" },
          },
        })
      end,
    },
  },
})

-------------------------------------------------------------------------------
