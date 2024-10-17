local M = {}


function M.get_cpu_usage()
	local cpu_usage = io.popen("top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}'"):read("*a")
	return string.format("CPU: %.2f%%", tonumber(cpu_usage) or 0)
end

function M.get_mem_usage()
	local mem_info = io.popen("free -m | grep Mem | awk '{print $3/$2 *100.0}'"):read("*a")
	return string.format("RAM: %.2f%%", tonumber(mem_info) or 0)
end

function M.get_sys_temp()
	local temp = io.popen("sensors | grep 'Package id 0:' | awk '{print $4}'"):read("*a")
	return "Temp: " .. (temp or "N/A")
end

function M.update_statusline()
	local cpu = M.get_cpu_usage()
	local mem = M.get_mem_usage()
	local temp = M.get_sys_temp()

	return table.concat({ cpu, mem, temp }, " | ")
end

-- Set statusline
vim.o.statusline = "%!v:lua.require'statusline'.update_statusline()"

-- Update status line every 5 secs
vim.cmd([[
	augroup UpdateStatusline
		autocmd!
		autocmd CursorHold,CursorHoldI * redrawstatus
	augroup END
]])

return M
