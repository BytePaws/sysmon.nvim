local sysmon = require("sysmon.sysmon")
local eq = assert.are.same

describe("Sysmon Plugin", function()
	-- Test: Update System Function
	it("should update CPU, memory and temperature stats", function()
		sysmon.update_sys()

		-- Mock data for tests
		local expected_cpu = "CPU: 14.8%"
		local expected_mem = "Mem: 5,37%"
		local expected_temp = "Temp: +45.0°C"

		-- Validate cache values are populated
		assert.is_not_nil(sysmon.update_statusline())
		assert.is_true(sysmon.update_statusline():find(expected_cpu) ~= nil)
		assert.is_true(sysmon.update_statusline():find(expected_mem) ~= nil)
		assert.is_true(sysmon.update_statusline():find(expected_temp) ~= nil)
	end)

	it("should apply user configuration correctly", function()
		sysmon.setup({
			update_interval = 5000,
			use_icons = true,
		})

		eq(5000, sysmon.config.update_interval)
		eq(true, sysmon.config.use_icons)
	end)
end)
