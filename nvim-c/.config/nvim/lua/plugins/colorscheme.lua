vim.pack.add({
	{
		src = "https://github.com/catppuccin/nvim",
		name = "catppuccin",
	},
})

require("catppuccin").setup({
	flavour = "macchiato",

	no_italic = true,

	integrations = {
		treesitter = true,

		native_lsp = {
			enabled = true,
		},

		blink_cmp = {
			style = "bordered",
		},
	},

	custom_highlights = function(colors)
		return {
			-- ==================================================================
			-- Statusline
			-- ==================================================================

			StatusModeNormal = {
				fg = colors.base,
				bg = colors.green,
				bold = true,
			},

			StatusModeInsert = {
				fg = colors.base,
				bg = colors.blue,
				bold = true,
			},

			StatusModeVisual = {
				fg = colors.base,
				bg = colors.mauve,
				bold = true,
			},

			StatusModeCommand = {
				fg = colors.base,
				bg = colors.peach,
				bold = true,
			},

			StatusModeReplace = {
				fg = colors.base,
				bg = colors.red,
				bold = true,
			},

			StatusModeTerminal = {
				fg = colors.base,
				bg = colors.teal,
				bold = true,
			},

			StatusFile = {
				fg = colors.text,
				bold = true,
			},

			StatusModified = {
				fg = colors.yellow,
				bold = true,
			},

			StatusReadonly = {
				fg = colors.overlay1,
			},

			StatusSeparator = {
				fg = colors.surface2,
			},

			StatusLsp = {
				fg = colors.sapphire,
				bold = true,
			},

			StatusError = {
				fg = colors.red,
				bold = true,
			},

			StatusWarn = {
				fg = colors.yellow,
				bold = true,
			},

			StatusProgress = {
				fg = colors.sky,
			},

			StatusFiletype = {
				fg = colors.teal,
				bold = true,
			},

			StatusLocation = {
				fg = colors.subtext1,
			},

			StatusPercent = {
				fg = colors.subtext0,
			},

			-- ==================================================================
			-- LSP references
			-- ==================================================================

			LspReferenceText = {
				bg = colors.surface0,
			},

			LspReferenceRead = {
				bg = colors.surface0,
			},

			LspReferenceWrite = {
				bg = colors.surface0,
			},
		}
	end,
})

vim.opt.termguicolors = true

vim.cmd.colorscheme("catppuccin")

