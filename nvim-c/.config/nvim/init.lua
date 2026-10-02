require("config")
require("plugins")
require("autoclose").setup()
require("pick").setup()

vim.keymap.set("n", "<leader>w", function()
  vim.cmd.write()
  vim.cmd("echo ''")
end)
