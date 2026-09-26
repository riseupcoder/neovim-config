local M = {}

M.defaults = {
	generator = {
		author = "user",
		use_lombok = false,
	},
	runner = {
		terminal_height = 15,
	},
	notifications = { enabled = true, timeout = 3000 },
	initializer = {
		java_versions = { "21", "25" },
		boot_versions = { "Latest" },
		default_name = "demo-app",
		default_group = "com.example",
		default_deps = "web,lombok",
	},
	build_tool = "maven",
	default_keymaps = true,
}

M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
