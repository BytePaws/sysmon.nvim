-- Load the core system monitor functionality
local sysmon = require("sysmon.sysmon")

lvim.builtin.lualine.sections.lualine_c = {
	{
		function()
			return sysmon.update_statusline()
		end,
	},
}

-- start the timer to update stats
sysmon.start_timer()

-- Cleanupt timer upon exit
vim.cmd([[
	autocmd VimLeavePre * lua require('sysmon.sysmon').stop_timer()
]])
