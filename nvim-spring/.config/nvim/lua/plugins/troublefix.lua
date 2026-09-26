vim.pack.add({
  "https://github.com/folke/trouble.nvim"
})

require("trouble").setup()

-- 3. Define Keymaps (Matching Official Docs)
local keymap = vim.keymap

-- Workspace Diagnostics (All files)
keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })

-- Buffer Diagnostics (Current file only)
keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })

-- Quickfix List (Using Trouble UI)
keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- Location List
keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
