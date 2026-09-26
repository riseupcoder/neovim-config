require("config.options")
require("config.keymaps")
require("config.statusline")
require("plugins")
require("autoclose").setup()

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit Neovim' })

vim.keymap.set("n", "<leader>w", function()
  vim.cmd.write()
  vim.cmd("echo ''")
end)

vim.cmd.colorscheme "catppuccin"   
