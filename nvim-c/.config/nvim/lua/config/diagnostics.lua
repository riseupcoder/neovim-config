local map = vim.keymap.set
local sev = vim.diagnostic.severity

local palette = {
	err = "#51202A",
	warn = "#3B3B1B",
	info = "#1F3342",
	hint = "#1E2E1E",
}

-- Diagnostic line highlights
vim.api.nvim_set_hl(0, "DiagnosticErrorLine", {
	bg = palette.err,
	blend = 20,
})

vim.api.nvim_set_hl(0, "DiagnosticWarnLine", {
	bg = palette.warn,
	blend = 15,
})

vim.api.nvim_set_hl(0, "DiagnosticInfoLine", {
	bg = palette.info,
	blend = 10,
})

vim.api.nvim_set_hl(0, "DiagnosticHintLine", {
	bg = palette.hint,
	blend = 10,
})

vim.diagnostic.config({
	-- Neovim defaults this to false; keep it enabled.
	severity_sort = true,
        update_in_insert = true,

	float = {
		border = "rounded",
		source = true,
	},

	signs = {
		text = {
			[sev.ERROR] = " ",
			[sev.WARN] = " ",
			[sev.INFO] = " ",
			[sev.HINT] = "󰌵 ",
		},

		linehl = {
			[sev.ERROR] = "DiagnosticErrorLine",
		},
	},

	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
	},
})

-- Show diagnostics for the current line.
map("n", "<leader>cd", vim.diagnostic.open_float, {
	desc = "Line Diagnostics",
})

local function diagnostic_goto(count, severity)
	return function()
		vim.diagnostic.jump({
			count = count,
			float = true,
			severity = severity,
		})
	end
end

-- Severity-specific navigation.
map("n", "]e", diagnostic_goto(1, sev.ERROR), {
	desc = "Next Error",
})

map("n", "[e", diagnostic_goto(-1, sev.ERROR), {
	desc = "Previous Error",
})

map("n", "]w", diagnostic_goto(1, sev.WARN), {
	desc = "Next Warning",
})

map("n", "[w", diagnostic_goto(-1, sev.WARN), {
	desc = "Previous Warning",
})

