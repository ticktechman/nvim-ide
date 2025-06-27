-------------------------------------------------------------------------------
--
--       filename: options.lua
--    description:
--        created: 2025/06/27
--         author: ticktechman
--
-------------------------------------------------------------------------------

local o = vim.opt
local cs = vim.cmd.colorscheme

o.number = true
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.termguicolors = true
o.syntax = "enable"
o.clipboard = "unnamedplus"
vim.o.undofile = true

cs("catppuccin")
-------------------------------------------------------------------------------
