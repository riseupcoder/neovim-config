local M = {}

local function get_input(prompt, default, callback)
	vim.ui.input({ prompt = prompt, default = default }, function(input)
		if not input or input == "" then
			vim.notify("⚠️ Canceled: No input provided", vim.log.levels.WARN, { title = "Spring-Gen" })
			return
		end
		callback(input)
	end)
end

local function get_select(prompt, options, callback)
	vim.ui.select(options, { prompt = prompt }, function(choice)
		if not choice then
			vim.notify("⚠️ Canceled: No option selected", vim.log.levels.WARN, { title = "Spring-Gen" })
			return
		end
		callback(choice)
	end)
end

local function execute_init(name, group, java_ver, boot_ver, deps)
	local base_url = "https://start.spring.io/starter.zip"
	local boot_param = boot_ver == "Latest" and "" or ("&bootVersion=" .. boot_ver)

	local query = string.format(
		"type=gradle-project&language=java&baseDir=%s&groupId=%s&artifactId=%s&name=%s&javaVersion=%s&dependencies=%s%s",
		name,
		group,
		name,
		name,
		java_ver,
		deps,
		boot_param
	)
	local full_url = base_url .. "?" .. query

	vim.notify("🚀 Initializing " .. name .. "...", vim.log.levels.INFO, { title = "Spring-Gen" })

	local zip_file = name .. ".zip"
	local cmd = string.format(
		"curl -sL %s -o %s && unzip -o %s && rm %s",
		vim.fn.shellescape(full_url),
		vim.fn.shellescape(zip_file),
		vim.fn.shellescape(zip_file),
		vim.fn.shellescape(zip_file)
	)

	vim.fn.jobstart(cmd, {
		cwd = vim.fn.getcwd(),
		on_exit = function(_, exit_code)
			if exit_code == 0 then
				vim.notify(
					"✅ Project '" .. name .. "' created successfully!",
					vim.log.levels.INFO,
					{ title = "Spring-Gen" }
				)
			else
				vim.notify(
					"❌ Process failed. Check your version compatibility.",
					vim.log.levels.ERROR,
					{ title = "Spring-Gen" }
				)
			end
		end,
	})
end

function M.create_project()
	local cfg = require("spring-gen.config").options.initializer

	get_input("1/5 Project Name: ", cfg.default_name, function(name)
		get_input("2/5 Group ID: ", cfg.default_group, function(group)
			get_select("3/5 Select Java Version:", cfg.java_versions, function(java_ver)
				get_select("4/5 Select Spring Boot Version:", cfg.boot_versions, function(boot_ver)
					get_input("5/5 Dependencies (comma separated): ", cfg.default_deps, function(deps)
						execute_init(name, group, java_ver, boot_ver, deps)
					end)
				end)
			end)
		end)
	end)
end

return M
