-----------------------------------------------------------
-- General
-----------------------------------------------------------

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Don't wrap long lines
vim.opt.wrap = true

-- Keep wrapped lines visually indented if wrapping is enabled elsewhere.
vim.opt.breakindent = true

-- Faster CursorHold events and related plugin/LSP behavior.
vim.opt.updatetime = 250

-- Persistent undo history
vim.opt.undofile = true

-----------------------------------------------------------
-- UI
-----------------------------------------------------------

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Don't show "-- INSERT --", etc.
vim.opt.showmode = false

-- 24-bit colors
vim.opt.termguicolors = true

-- Always reserve the sign column so diagnostics don't shift the screen.
vim.opt.signcolumn = "yes"

-- Highlight the current line.
vim.opt.cursorline = true

-- Keep some context around the cursor.
vim.opt.scrolloff = 8

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-----------------------------------------------------------
-- Search
-----------------------------------------------------------

-- Case-insensitive search unless uppercase is used.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-----------------------------------------------------------
-- Yank Highlight
-----------------------------------------------------------

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


vim.opt.modeline = false
vim.opt.shadafile = "NONE"

vim.keymap.set("n", "<leader>t", ":w<CR>:vertical rightbelow term cd %:p:h && clang -std=c23 -Wall -Wextra %:t -o %:t:r -lm && ./%:t:r<CR>", {
	silent = true,
	noremap = true,
	desc = "Compile and run C",
})


