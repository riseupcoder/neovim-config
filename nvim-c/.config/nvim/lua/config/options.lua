-- ============================================================================
-- General
-- ============================================================================

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- wrap long source-code lines.
vim.opt.wrap = true

-- Faster CursorHold events for diagnostics and related UI.
vim.opt.updatetime = 250

-- Persistent undo history.
vim.opt.undofile = true

-- ============================================================================
-- UI
-- ============================================================================

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Mode is already shown by the custom statusline.
vim.opt.showmode = false

-- 24-bit colors
vim.opt.termguicolors = true

-- Keep the sign column stable so diagnostics do not shift the text.
vim.opt.signcolumn = "yes"

-- Highlight the current line.
vim.opt.cursorline = true

-- Keep context around the cursor.
vim.opt.scrolloff = 8

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- ============================================================================
-- Search
-- ============================================================================

-- Case-insensitive unless the search contains uppercase characters.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ============================================================================
-- Yank Highlight
-- ============================================================================

local yank_group = vim.api.nvim_create_augroup("highlight_yank", {
	clear = true,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	desc = "Highlight selection on yank",

	callback = function()
		vim.highlight.on_yank({
			timeout = 200,
			visual = true,
		})
	end,
})

-- Disable automatic comment continuation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- ============================================================================
-- Security / Persistence
-- ============================================================================

-- Do not allow files to change editor options through modelines.
vim.opt.modeline = false

-- Auto Save
local group = vim.api.nvim_create_augroup("autosave", {
	clear = true,
})

vim.api.nvim_create_autocmd({
	"InsertLeave",
	"FocusLost",
	"BufLeave",
	"VimLeavePre",
}, {
	group = group,

	callback = function()
		local buf = vim.api.nvim_get_current_buf()

		if vim.bo[buf].buftype ~= ""
			or not vim.bo[buf].modifiable
			or vim.bo[buf].readonly
			or vim.api.nvim_buf_get_name(buf) == ""
		then
			return
		end

		vim.cmd("silent update")
	end,
})

