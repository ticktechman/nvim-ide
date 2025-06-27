-------------------------------------------------------------------------------
--
--       filename: quickfix.lua
--    description:
--        created: 2025/06/27
--         author: ticktechman
--
-------------------------------------------------------------------------------

local M = {}

function M.toggle()
  local fn = vim.fn
  local cmd = vim.cmd

  local wins = fn.getwininfo()
  local quickfix_open = false
  for _, win in ipairs(wins) do
    if win.quickfix == 1 then
      quickfix_open = true
      break
    end
  end

  if quickfix_open then
    cmd("cclose")
  else
    cmd("copen")
  end
end

function M.setup()
  vim.keymap.set("n", "<leader>,", M.toggle, { remap = true, desc = "Toggle QuickFix" })
end

return M

-------------------------------------------------------------------------------
