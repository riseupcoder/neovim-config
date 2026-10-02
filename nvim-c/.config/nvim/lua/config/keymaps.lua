local map = vim.keymap.set

-- ============================================================================
-- Leader
-- ============================================================================

-- Space is the leader key.
-- Disable its default behavior so it doesn't interfere with leader mappings.
map("n", "<leader>", "<nop>")
map("v", "<leader>", "<nop>")

-- ============================================================================
-- File navigation
-- ============================================================================

map("n", "-", "<cmd>Oil<cr>", {
	desc = "Open Parent Directory",
})

map("n", "<leader>ff", "<cmd>Pick files<cr>", {
	desc = "Find Files",
})

map("n", "<leader>fb", "<cmd>Pick buffers<cr>", {
	desc = "Switch Buffer",
})

-- ============================================================================
-- Insert mode
-- ============================================================================

map("i", "jj", "<Esc>", {
	desc = "Exit Insert Mode",
})

-- ============================================================================
-- Clipboard
-- ============================================================================

-- Paste without overwriting the yank register.
map("n", "<leader>p", '"_dP', {
	desc = "Paste Without Overwriting",
})

-- Paste from system clipboard.
--
-- If you prefer <leader>p to always mean system clipboard paste,
-- remove the mapping above and keep only this one.
map("n", "<leader>P", '"+p', {
	desc = "Paste From System Clipboard",
})

-- Yank to system clipboard.
map("n", "<leader>y", '"+y', {
	desc = "Yank to System Clipboard",
})

map("v", "<leader>y", '"+y', {
	desc = "Yank to System Clipboard",
})

map("n", "<leader>Y", '"+Y', {
	desc = "Yank Line to System Clipboard",
})

-- ============================================================================
-- C development
-- ============================================================================

map("n", "<leader>t", function()
	vim.cmd.write()

	vim.cmd(
		"vertical rightbelow term cd %:p:h && "
			.. "clang -std=c23 -Wall -Wextra %:t "
			.. "-o %:t:r -lm && ./%:t:r"
	)
end, {
	desc = "Compile and Run C",
})

-- ============================================================================
-- Save / quit
-- ============================================================================

map("n", "<leader>w", "<cmd>write<cr><cmd>echo ''<cr>", {
	desc = "Save File",
})

map("n", "<leader>q", "<cmd>quit<cr>", {
	desc = "Quit Window",
})

