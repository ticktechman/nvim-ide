local o = vim.opt
local cs = vim.cmd.colorscheme

o.number = true
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.termguicolors = true
o.syntax = "enable"
o.clipboard = "unnamedplus"

cs("catppuccin")
