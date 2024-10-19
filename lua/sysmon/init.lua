local sysmon = require("sysmon.sysmon")

-- Expose setup function for external configuration
local M = {}

M.setup = function(user_config)
	sysmon.setup(user_config) -- Apply user configuration to sysmon

	lvim.builtin.lualine.sections.lualine_c = {
		{
			function()
				return sysmon.update_statusline()
			end,
		},
	}

	-- Start the timer
	sysmon.start_timer()

	-- Cleanup timer upon exit
	vim.cmd([[
        autocmd VimLeavePre * lua require('sysmon.sysmon').stop_timer()
    ]])
end

return M
