-------------------------------------------------------------------------------
--
--       filename: mappings.lua
--    description:
--        created: 2025/06/27
--         author: ticktechman
--
-------------------------------------------------------------------------------

local g = vim.g
local map = vim.keymap.set

g.mapleader = ","

-- common
map("n", "<leader>z", ":q!<CR>")
map("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
-- map("n", "<leader>t", ":TagbarToggle<CR>", { noremap = true, silent = true })
map("n", "<leader>t", ":SymbolsOutline<CR>", { noremap = true, silent = true })

-- windows navigation
map("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
map("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
map("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
map("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })

--------------------
-- telescope
--------------------
local telescope = require("telescope.builtin")
map("n", "<leader>ff", telescope.find_files, { desc = "Telescope find files" })
map("n", "<leader>fg", telescope.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", telescope.buffers, { desc = "Telescope buffers" })
map("n", "<leader>fh", telescope.help_tags, { desc = "Telescope help tags" })

--------------------
-- comments
--------------------
map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

--------------------
-- quick fix toggle
--------------------
require("quickfix").setup()
-------------------------------------------------------------------------------
