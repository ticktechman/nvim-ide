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
local cmd = vim.cmd

g.mapleader = ","

-- common
map("n", "<leader>z", ":q!<CR>")
map("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

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
map("n", "<leader>,", ":call QuickFixToggle()<CR>", { remap = true })

cmd([[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
]])

-------------------------------------------------------------------------------
