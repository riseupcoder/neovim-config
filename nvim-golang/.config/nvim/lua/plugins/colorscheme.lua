vim.pack.add { "https://github.com/catppuccin/nvim" }

require("catppuccin").setup({
        flavour = "mocha", -- or "latte", "frappe", "macchiato"
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
          },
          blink_cmp = {
    	    style = 'bordered',
	  },
	  blink_cmp = true,
        },
	
       no_italic = true, -- Force no italic
})
vim.opt.termguicolors = true
vim.cmd.colorscheme("catppuccin")
