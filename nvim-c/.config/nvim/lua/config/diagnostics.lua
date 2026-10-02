local map = vim.keymap.set
local diagnostic = vim.diagnostic
local sev = diagnostic.severity

-- ============================================================================
-- Diagnostic configuration
-- ============================================================================

diagnostic.config({
	-- More severe diagnostics are displayed first.
	severity_sort = true,

	-- Avoid constantly changing diagnostics while typing.
	-- Diagnostics update when leaving Insert mode.
	update_in_insert = false,

	-- ==========================================================================
	-- Signs
	-- ==========================================================================

	-- ASCII intentionally: no Nerd Font required.
	signs = {
		text = {
			[sev.ERROR] = "E",
			[sev.WARN] = "W",
			[sev.INFO] = "I",
			[sev.HINT] = "H",
		},

		-- Highlight the affected line number.
		-- Catppuccin supplies the diagnostic colors.
		numhl = {
			[sev.ERROR] = "DiagnosticSignError",
			[sev.WARN] = "DiagnosticSignWarn",
			[sev.INFO] = "DiagnosticSignInfo",
			[sev.HINT] = "DiagnosticSignHint",
		},
	},

	-- ==========================================================================
	-- Source code
	-- ==========================================================================

	-- Highlight the exact diagnostic range.
	underline = true,

	-- Keep the actual diagnostic message visible.
	--
	-- This is useful for C/C++ because:
	--
	--     E 42  foo();
	--             ^~~~~ implicit declaration of function 'foo'
	--
	-- We don't have to open a float just to see the compiler message.
	virtual_text = {
		spacing = 2,
		source = "if_many",

		-- Small ASCII prefix; no Nerd Font required.
		prefix = "›",
	},

	-- ==========================================================================
	-- Floating window
	-- ==========================================================================

	float = {
		border = "rounded",
		source = true,
		header = "",
	},

	-- ==========================================================================
	-- Navigation
	-- ==========================================================================

	jump = {
		float = true,
		wrap = true,
	},
})

-- ============================================================================
-- Current-line diagnostics
-- ============================================================================

map("n", "<leader>cd", diagnostic.open_float, {
	desc = "Line Diagnostics",
})

-- ============================================================================
-- Diagnostic navigation
-- ============================================================================

local function diagnostic_goto(count, severity)
	return function()
		diagnostic.jump({
			count = count,
			severity = severity,
			float = true,
		})
	end
end

-- Any diagnostic
map("n", "]d", diagnostic_goto(1), {
	desc = "Next Diagnostic",
})

map("n", "[d", diagnostic_goto(-1), {
	desc = "Previous Diagnostic",
})

-- Errors
map("n", "]e", diagnostic_goto(1, sev.ERROR), {
	desc = "Next Error",
})

map("n", "[e", diagnostic_goto(-1, sev.ERROR), {
	desc = "Previous Error",
})

-- Warnings
map("n", "]w", diagnostic_goto(1, sev.WARN), {
	desc = "Next Warning",
})

map("n", "[w", diagnostic_goto(-1, sev.WARN), {
	desc = "Previous Warning",
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
  end,
})
