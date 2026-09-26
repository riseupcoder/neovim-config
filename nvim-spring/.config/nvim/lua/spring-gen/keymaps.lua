local M = {}

-- No need to require or schedule which-key anymore
local function register_wk()
  -- NOOP: which-key is removed. Group info now comes from `desc` in keymaps.
  -- Neovim's UI tools (Telescope, Lazy, etc.) will infer groups from leader sequences.
end

function M.setup()
  local spring_gen = require("spring-gen")

  -- Helper to set keymaps with descriptions
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
  end

  -- Leader-J mappings: Grouped under "Spring Boot" via `desc`
  -- The prefix "<leader>J" + shared description enables UI grouping
  map("n", "<leader>Jn", function()
    local options = { "Class", "Interface", "Enum", "Record", "RestController", "Service" }
    vim.ui.select(options, { prompt = "Create Java Component:" }, function(choice)
      if choice then
        spring_gen.create_java_file(choice)
      end
    end)
  end, "[Spring Boot] Component Generator")

  map("n", "<leader>Jr", function()
    local options = { "Normal Run", "Clean Run" }
    vim.ui.select(options, { prompt = "Choose Run type:" }, function(choice)
      if choice then
        local is_clean = (choice == "Clean Run")
        spring_gen.run_spring_boot(is_clean)
      end
    end)
  end, "[Spring Boot] Run")

  map("n", "<leader>Js", function()
    spring_gen.stop_spring_boot()
  end, "[Spring Boot] Stop")

  map("n", "<leader>Jp", function()
    spring_gen.create_project()
  end, "[Spring Boot] Project Initializer")

  -- Call register_wk() for API compatibility (noop now)
  register_wk()
end

return M
