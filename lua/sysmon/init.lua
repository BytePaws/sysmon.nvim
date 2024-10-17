-- Load the core system monitor functionality
local sysmon = require("sysmon.sysmon")

lvim.builtin.lualine.sections.lualine_c = {
	{
		function()
			return sysmon.update_statusline()
		end,
	},
}

-- Update the system stats on CursorHold (trigger the updates periodically)
vim.cmd([[
  augroup UpdateStatusline
    autocmd!
    autocmd CursorHold,CursorHoldI * lua pcall(function() require('sysmon.sysmon').update_sys() end)
  augroup END
]])
