local M = {}

-- Cache last values
local cpu_c, mem_c, temp_c = "", "", ""
local last_update = 0
local interval = 10000 -- 5000 milliseconds (5 secs)

-- Execute shell commands asynchronously
--- @param cmd string the the bash command to execute
--- @param callback function the callback to handle command results
local function run_command(cmd, callback)
	local stdout = vim.loop.new_pipe(false)
	local stderr = vim.loop.new_pipe(false)
	--- @type uv_handle_t | nil
	local handle
	handle = vim.loop.spawn("bash", {
		args = { "-c", cmd },
		stdio = { nil, stdout, stderr },
	}, function(code, signal)
		if handle == nil then
			callback(nil, "Failed to spawn process")
		end
		if code ~= 0 then
			callback(nil, code, signal) -- Send error code if command fails
		end
		handle:close()         -- Close process handle after execution
	end)

	if handle then -- Check if handle gets returned
		-- Read stdout data if any
		stdout:read_start(function(err, data)
			if err then
				callback(nil, err)
			elseif data then
				callback(data, nil)
			end
		end)

		-- Check for data in stderr
		stderr:read_start(function(err, data)
			if data then
				-- Handle stderr if needed
				vim.notify("Error: " .. data, vim.log.levels.ERROR)
			end
		end)
	else
		callback(nil, "Failed to spawn process")
	end
end

function M.get_cpu_usage(callback)
	run_command("top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}'", function(output, err)
		if err then
			callback("CPU: N/A")
		else
			local cpu = tonumber(output)
			if cpu then
				callback(string.format("CPU: %.2f%%", cpu))
			else
				callback("CPU: N/A")
			end
		end
	end)
end

function M.get_mem_usage(callback)
	run_command("free -m | grep Mem | awk '{print $3/$2 * 100.0}'", function(output, err)
		if err then
			callback("Mem: N/A")
		else
			local mem = tonumber(output)
			if mem then
				callback(string.format("Mem: %.2f%%", mem))
			else
				callback("Mem: N/A")
			end
		end
	end)
end

function M.get_sys_temp(callback)
	run_command("sensors | grep 'Package id 0:' | awk '{print $4}'", function(output, err)
		if err then
			callback("Temp N/A")
		else
			local temp = output.match("%d+%.%d+")
			if temp then
				callback("Temp: " .. temp .. "°C")
			else
				callback("Temp: N/A")
			end
		end
	end)
end

-- Update system stats asynchronously
local function update_sys()
	local time = vim.loop.now()
	if time - last_update < interval then
		return -- Don't update if the last one was too recent
	end

	last_update = time

	M.get_cpu_usage(function(cpu)
		cpu_c = cpu
		vim.defer_fn(function()
			vim.cmd("redrawstatus") -- safely redraw the statusline
		end, 0) -- Defer execution to allow redraw
	end)

	M.get_mem_usage(function(mem)
		mem_c = mem
		vim.defer_fn(function()
			vim.cmd("redrawstatus")
		end, 0)
	end)

	M.get_sys_temp(function(temp)
		temp_c = temp
		vim.defer_fn(function()
			vim.cmd("redrawstatus")
		end, 0)
	end)
end

function M.update_statusline()
	update_sys()

	return table.concat({ cpu_c, mem_c, temp_c }, " | ")
end

return M
