local M = {}

-- Cached values to avoid unnecessary updates
local cached_cpu, cached_mem, cached_temp = "", "", ""
local last_update = 0
local update_interval = 5000 -- 5 seconds

-- Utility function to run shell commands asynchronously
local function run_command(cmd, callback)
	local stdout = vim.loop.new_pipe(false)
	local stderr = vim.loop.new_pipe(false)
	local handle

	handle = vim.loop.spawn("bash", {
		args = { "-c", cmd },
		stdio = { nil, stdout, stderr },
	}, function()
		stdout:read_stop()
		stderr:read_stop()
		stdout:close()
		stderr:close()
		handle:close()
	end)

	stdout:read_start(function(_, data)
		if data then
			callback(data)
		end
	end)

	stderr:read_start(function(_, data)
		if data then
			vim.notify("Error: " .. data, vim.log.levels.ERROR)
		end
	end)
end

-- Trim whitespace utility function
local function trim(str)
	return str:match("^%s*(.-)%s*$") or ""
end

-- Update system stats (throttled by a 5-second interval)
function M.update_sys()
	local current_time = vim.loop.now()
	if current_time - last_update < update_interval then
		return -- Skip the update if it's too soon
	end
	last_update = current_time

	-- Fetch CPU usage
	run_command("top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'",
		function(cpu)
			cached_cpu = "CPU: " .. trim(cpu)
		end)

	-- Fetch memory usage
	run_command("free -m | awk 'NR==2{printf \"Mem: %s/%sMB\", $3,$2 }'", function(mem)
		cached_mem = trim(mem)
	end)

	-- Fetch system temperature
	run_command("sensors | awk '/^CPU:/{print $2}'", function(temp)
		cached_temp = "Temp: " .. trim(temp)
	end)
end

-- Return system stats for the statusline
function M.update_statusline()
	return table.concat({ cached_cpu, cached_mem, cached_temp }, " | ")
end

return M
