local sysmon = require("sysmon.sysmon")

-- Set statusline
vim.o.statusline = "%!v:lua.require'statusline'.update_statusline()"

-- Update status line every 5 secs
vim.cmd([[
	augroup UpdateStatusline
		autocmd!
		autocmd CursorHold,CursorHoldI * redrawstatus
	augroup END
]])
