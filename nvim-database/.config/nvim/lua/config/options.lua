-----------------------------------------------------------
-- General
-----------------------------------------------------------
-- Set leader key to space
vim.g.mapleader = " "
-- Set leader key to space
vim.g.maplocalleader = " "

-- Number of spaces a tab represents
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Use appropriate when using indent command
vim.opt.expandtab = true
vim.opt.shiftwidth = 4

-- Indenting correctly after { etc
vim.opt.smartindent = true

-- Copy indent from current line when starting new line
vim.opt.autoindent = true

-- Prevent line wrapping
vim.opt.breakindent = true

-- Disable text wrap
vim.opt.wrap = true

-- Speeds up plugin wait time
vim.opt.updatetime = 50

-- Persistant undo file history
vim.opt.undofile = true
-----------------------------------------------------------
-- UI Config
-----------------------------------------------------------
-- Enable line numbers
vim.opt.nu = true

-- Enable relative line numbers
vim.opt.rnu = true

-- Disable showing the mode below the statusline
vim.opt.showmode = false

-- Enable 24-bit color
vim.opt.termguicolors = true

-- Enable the sign column to prevent the screen from jumping
vim.opt.signcolumn = "yes"

-- Enable cursor line highlight
vim.opt.cursorline = true

-- Always keep 8 lines above/below cursor unless at start/end of file
vim.opt.scrolloff = 8

-- Better splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Faster scrolling
vim.opt.lazyredraw = true

-- Highlight yank
vim.api.nvim_create_autocmd("textyankpost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    pattern = "*",
    desc = "highlight selection on yank",
    callback = function()
      vim.highlight.on_yank({ timeout = 200, visual = true })
   end,
})

-----------------------------------------------------------
-- Search Config
-----------------------------------------------------------
-- Enable highlighting search in progress
vim.opt.incsearch = true

-- Ignore case for searches
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.diagnostic.config({
  virtual_text = {
    prefix = '●', -- Could use '●', '■', '▎', '▶', etc.
    spacing = 2,
    source = true,  -- Show the diagnostic source (eslint, tsserver, etc)
    severity = { min = vim.diagnostic.severity.WARN }, -- Only show warnings/errors in virtual text
  },
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always", -- Show source in float (e.g., ESLint, tsserver)
    header = "",
    prefix = "",
  },
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.HINT]  = "",
      [vim.diagnostic.severity.INFO]  = "",
    },
  },
})

-- 2. Customize sign colors
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#EF596F", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn",  { fg = "#E5C07B", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo",  { fg = "#61AFEF", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint",  { fg = "#98C379", bg = "NONE" })

-- 3. Optionally, theme virtual text and underline (example)
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#EF596F", bg = "#51202A" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#EF596F" })

-- global lsp attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client.server_capabilities.documentFormattingProvider then
      return
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({ async = true })
      end,
    })
  end,
})

--database
vim.g.db_ui_execute_on_save = 0
vim.g.db_ui_winwidth = 30
vim.g.db_ui_save_location = '/home/user/sql'
vim.keymap.set("n", "<leader>t", "vip<Plug>(DBUI_ExecuteQuery)<Cmd>wincmd w<CR>", { desc = "Run query under cursor" })
vim.keymap.set("n", "<C-d>", "<cmd>DBUIToggle<CR>", { desc = "Toggle DBUI" })


vim.opt.fillchars = {
        foldopen = "",
        foldclose = "",
        fold = " ",
        foldsep = " ",
        diff = "╱",
        eob = " ",
}
