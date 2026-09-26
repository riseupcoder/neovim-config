local config = require("spring-gen.config")
local M = {}

M.setup = function(opts)
	config.setup(opts)

	local options = config.options

	if options.default_keymaps then
		require("spring-gen.keymaps").setup()
	end
end

M.create_java_file = function(type)
	require("spring-gen.generator").create_java_file(type)
end

M.run_spring_boot = function(clean)
	require("spring-gen.runner").run_spring_boot(clean)
end

M.stop_spring_boot = function()
	require("spring-gen.runner").stop_spring_boot(true)
end

M.create_project = function()
	require("spring-gen.initializer").create_project()
end

return M
