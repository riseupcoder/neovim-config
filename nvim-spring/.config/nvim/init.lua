require("config")
require("plugins")
require("autoclose").setup()
require("spring-gen").setup({})
require("pick").setup()

vim.o.updatetime = 250  -- Faster CursorHold event

vim.opt.modeline = false

vim.opt.shadafile = "NONE"

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
  end,
})

vim.keymap.set("n", "<leader>w", function()
  vim.cmd.write()
  vim.cmd("echo ''")
end)

vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#1e1e2e" })

vim.cmd('autocmd BufEnter * set formatoptions-=ro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=ro')

local pick = require("pick")

local function get_project_root()
  local markers = { "pom.xml", "build.gradle", "settings.gradle", ".git" }
  local root = vim.fs.root(0, markers)
  return root or vim.fn.getcwd()
end

-- SIMPLIFIED: Keeps only the last N segments (e.g., last 4)
local function shorten_path(path, max_width)
  if not path or #path <= max_width then return path end

  local segments = {}
  for segment in path:gmatch("[^/]+") do
    table.insert(segments, segment)
  end

  -- If path is short enough, return as is
  if #segments <= 4 then return path end

  -- Keep only the last 4 segments: [feature]/[layer]/[sub]/[File.java]
  -- Adjust '4' to '3' if you want even shorter paths (e.g., layer/sub/File)
  local start_idx = #segments - 2 
  local short_parts = {}
  for i = start_idx, #segments do
    table.insert(short_parts, segments[i])
  end

  return table.concat(short_parts, "/")
end

local function show_short_paths(buf_id, items, query)
  local state = pick.get_picker_state()
  if not state or not state.windows or not state.windows.main then
    pick.default_show(buf_id, items, query, { show_icons = true })
    return
  end

  local win_width = vim.api.nvim_win_get_width(state.windows.main)
  local max_path_width = win_width - 8

  local short_items = vim.tbl_map(function(item)
    if type(item) == "string" then
      return shorten_path(item, max_path_width)
    end
    if type(item) == "table" and item.bufnr then
      local full_path = vim.api.nvim_buf_get_name(item.bufnr)
      if full_path and full_path ~= "" then
        local new_item = vim.deepcopy(item)
        new_item.text = shorten_path(full_path, max_path_width)
        return new_item
      end
    end
    return item
  end, items)

  pick.default_show(buf_id, short_items, query, { show_icons = true })
end

pick.setup({
  source = {
    show = show_short_paths,
  },
})

vim.keymap.set("n", "<leader>ff", function()
  local root = get_project_root()
  local src_main = vim.fs.joinpath(root, "src", "main")
  
  if vim.fn.isdirectory(src_main) == 1 then
    pick.builtin.files(nil, { 
      source = { 
        cwd = src_main, 
        name = "Spring Main" 
      } 
    })
  else
    pick.builtin.files(nil, { 
      source = { 
        cwd = root, 
        name = "Project Files" 
      } 
    })
  end
end, { desc = "Find Spring Files" })

vim.keymap.set("n", "<leader>fb", function()
  local root = get_project_root()
  pick.builtin.buffers(nil, { source = { cwd = root } })
end, { desc = "Buffers" })

-- LSP Navigation
vim.keymap.set("n", "gd", function()
  vim.lsp.buf.definition()
end, { desc = "Go to Definition" })

vim.keymap.set("n", "gi", function()
  vim.lsp.buf.implementation()
end, { desc = "Go to Implementation" })

vim.keymap.set("n", "gr", function()
  vim.lsp.buf.references()
end, { desc = "Go to References" })

-- JUMP NAVIGATION: Easier keys (Leader + o/i)
vim.keymap.set("n", "<leader>b", "<C-o>", { desc = "Jump Back" })
vim.keymap.set("n", "<Tab>", "<C-i>", { desc = "Jump Forward" })

vim.keymap.set('n', '<leader>fm', function()
  local root_markers = { ".git", "pom.xml", "mvnw", "gradlew" }
  -- Detect project root
  local project_root = vim.fs.root(0, root_markers)

  if not project_root then
    vim.notify("Failed to detect project root (no pom.xml, gradlew, or .git found)", vim.log.levels.ERROR)
    return
  end

  -- Save current directory
  local original_dir = vim.fn.getcwd()

  -- Change to project root, run command, then restore
  vim.fn.chdir(project_root)
  vim.cmd('!./mvnw spring-javaformat:apply')
  vim.fn.chdir(original_dir)
  
  -- Optional: Refresh buffer if files changed externally
  vim.cmd('checktime')
end, { desc = 'Format with Maven Spring Plugin' }) -- < Closing paren and options table   

vim.opt.lazyredraw = true
