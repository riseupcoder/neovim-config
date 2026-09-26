vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("^1")
  }
})

local cmp = require('blink.cmp')

cmp.setup({
  keymap = {
    preset = "default",
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
    ["<CR>"] = { "accept", "fallback" }, -- Use Enter to confirm
  },
  appearance = {
    nerd_font_variant = 'mono',
    use_nvim_cmp_as_default = true, -- Cleaner look
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 250,
      window = { border = 'rounded' },
    },
    ghost_text = { enabled = false },
    accept = {
      auto_brackets = { enabled = true },
    },
    menu = {
      border = 'rounded',
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 2 },
          { "source_name", width = { max = 12 } },
        },
        components = {
          label = {
              width = { max = 17 }, -- Limit label width
          },
         source_name = {
              width = { max = 5 },
       	      text = function(ctx)
              return "[" .. ctx.source_name:sub(1, 3) .. "]"
              end,
             highlight = "Comment",
         },
        },
        treesitter = { "lsp" },
      },
      max_height = 10,
      winblend = 0,
    },
  },
  signature = {
    enabled = true,
    trigger = {
      enabled = true,
      show_on_trigger_character = true,
      show_on_insert = false,
    },
    window = {
      border = "rounded",
      winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
      show_documentation = true,
      max_height = 10,
    },
  },
  sources = {
    default = { 'buffer', 'lsp', 'snippets', 'path' },
    providers = {
      lsp = {
        score_offset = 50,
        async = true,
        fallbacks = { 'buffer' }
      },
      snippets = { score_offset = 30 },
      path = { score_offset = 10 },
      buffer = {
        score_offset = 100,
        async = true,
        opts = {
          get_bufnrs = function() return vim.api.nvim_list_bufs() end,
        }
      },
    },
  },
  fuzzy = { implementation = "lua" },   
})
