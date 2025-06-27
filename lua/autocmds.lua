-- goto last position
vim.cmd(
  'autocmd BufReadPost * if line("\'\\"") >= 1 && line("\'\\"") <= line("$") && &ft !~# \'commit\' | execute "normal! g`\\"" | endif'
)
