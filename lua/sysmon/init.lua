-- Load the core system monitor functionality
local sysmon = require("sysmon.sysmon")

-- Set the statusline in Neovim
vim.o.statusline = "%!v:lua.require'sysmon.sysmon'.update_statusline()"

-- Update the system stats on CursorHold (trigger the updates periodically)
vim.cmd([[
  augroup UpdateStatusline
    autocmd!
    autocmd CursorHold,CursorHoldI * lua require('sysmon.sysmon').update_sys()
  augroup END
]])
