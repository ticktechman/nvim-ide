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
  local wins = vim.fn.getwininfo()
  local opened = false
  for _, win in ipairs(wins) do
    if win.quickfix == 1 then
      opened = true
      break
    end
  end

  if opened then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end

function M.setup()
  vim.keymap.set("n", "<leader>,", M.toggle, { remap = true, desc = "Toggle QuickFix" })
end

return M

-------------------------------------------------------------------------------
