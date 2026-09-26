local M = {}

local state = {
	job_id = nil,
	buf_id = nil,
}

local PATTERNS = {
	SUCCESS = "Started .- in .- seconds",
	FAIL_BUILD = "BUILD FAILED",
	FAIL_APP = "APPLICATION FAILED TO START",
}

local function notify(msg, level, config)
	if not (config.notifications and config.notifications.enabled) then
		return
	end

	vim.schedule(function()
		vim.notify(msg, level, {
			title = "Spring-Gen",
			timeout = config.notifications.timeout or 3000,
		})
	end)
end

local function analyze_log_line(line, config)
	local clean_line = line:gsub("^%s*", "")

	if line:find(PATTERNS.SUCCESS) then
		notify("🚀 Spring Boot Started Successfully!", vim.log.levels.INFO, config)
		return true
	end

	if line:find(PATTERNS.FAIL_BUILD) or line:find(PATTERNS.FAIL_APP) then
		local err_conf = vim.deepcopy(config)
		if err_conf.notifications then
			err_conf.notifications.timeout = (err_conf.notifications.timeout or 3000) * 2
		end
		notify("❌ Error: " .. clean_line, vim.log.levels.ERROR, err_conf)
		return true
	end

	return false
end

local function attach_log_listener(buf_id, config)
	if not (config.notifications and config.notifications.enabled) then
		return
	end

	vim.api.nvim_buf_attach(buf_id, false, {
		on_lines = function(_, _, _, firstline, lastline)
			if not vim.api.nvim_buf_is_valid(buf_id) then
				return true
			end

			local lines = vim.api.nvim_buf_get_lines(buf_id, firstline, lastline, false)
			for _, line in ipairs(lines) do
				if analyze_log_line(line, config) then
					return true
				end
			end
		end,
	})
end

function M.run_spring_boot(clean)
  M.stop_spring_boot(false)
  local config = require("spring-gen.config").options
  local build_tool = config.build_tool or "gradle"

  -- Detect project root using common markers
  local root_markers = { ".git", "pom.xml", "mvnw", "gradlew" }
  local project_root = vim.fs.root(vim.fn.bufnr(), root_markers)

  if not project_root then
    vim.notify("Failed to detect project root", vim.log.levels.ERROR)
    return
  end

  -- Change to project root
  vim.fn.chdir(project_root)

  local cmd
  if build_tool == "maven" then
    cmd = clean and "./mvnw clean spring-boot:run" or "./mvnw spring-boot:run"
  else
    cmd = clean and "./gradlew clean bootRun" or "./gradlew bootRun"
  end

  local height = config.runner.terminal_height or 15
  vim.cmd("botright " .. height .. "split")
  vim.cmd("term " .. cmd)
  state.job_id = vim.b.terminal_job_id
  state.buf_id = vim.api.nvim_get_current_buf()
  vim.cmd("normal! G")
  attach_log_listener(state.buf_id, config)
end   

function M.stop_spring_boot(show_notification)
	local config = require("spring-gen.config").options

	if state.job_id then
		if vim.fn.jobwait({ state.job_id }, 0)[1] == -1 then
			vim.fn.jobstop(state.job_id)
		end
		state.job_id = nil

		if show_notification then
			notify("🛑 Spring Boot Stopped", vim.log.levels.INFO, config)
		end
	end

	if state.buf_id and vim.api.nvim_buf_is_valid(state.buf_id) then
		vim.api.nvim_buf_delete(state.buf_id, { force = true })
		state.buf_id = nil
	end
end

return M
