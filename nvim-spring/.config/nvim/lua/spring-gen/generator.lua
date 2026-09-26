local M = {}

local TYPE_CONFIG = {
	RestController = {
		type = "class",
		anno = "@RestController",
		imp = "org.springframework.web.bind.annotation.RestController",
	},
	Service = { type = "class", anno = "@Service", imp = "org.springframework.stereotype.Service" },
	Component = { type = "class", anno = "@Component", imp = "org.springframework.stereotype.Component" },
	Repository = { type = "class", anno = "@Repository", imp = "org.springframework.stereotype.Repository" },
	Interface = { type = "interface" },
	Enum = { type = "enum" },
	Record = { type = "record" },
	Class = { type = "class" },
}

local function get_package_from_path(path)
	local _, package_start = path:find("src/main/java/")
	if not package_start then
		return nil
	end

	local relative_path = path:sub(package_start + 1)
	local parts = vim.split(relative_path, "/")
	local clean_parts = vim.tbl_filter(function(v)
		return v ~= ""
	end, parts)

	return table.concat(clean_parts, ".")
end

local function build_file_content(opts)
	local lines = {}
	local config = require("spring-gen.config").options.generator

	-- Package
	table.insert(lines, "package " .. opts.package .. ";")
	table.insert(lines, "")

	-- Imports & Annotations Collecting
	local imports = {}
	local annotations = {}

	if opts.def.imp then
		table.insert(imports, "import " .. opts.def.imp .. ";")
	end
	if opts.def.anno then
		table.insert(annotations, opts.def.anno)
	end

	-- Lombok Support
	if config.use_lombok and opts.def.type == "class" and opts.def.anno then
		table.insert(imports, "import lombok.RequiredArgsConstructor;")
		table.insert(annotations, "@RequiredArgsConstructor")
	end

	-- Write Imports
	if #imports > 0 then
		for _, imp in ipairs(imports) do
			table.insert(lines, imp)
		end
		table.insert(lines, "")
	end

	-- Write Annotations
	for _, anno in ipairs(annotations) do
		table.insert(lines, anno)
	end

	-- Class/Interface Declaration
	local decl_prefix = "public " .. opts.def.type .. " " .. opts.name
	local decl_suffix = (opts.def.type == "record") and "() {" or " {"

	table.insert(lines, decl_prefix .. decl_suffix)
	table.insert(lines, "")
	table.insert(lines, "}")

	return lines
end

local M = {}

-- Assume TYPE_CONFIG and get_package_from_path/build_file_content are defined elsewhere in your file
-- local TYPE_CONFIG = { ... } 
-- local function get_package_from_path(path) ... end
-- local function build_file_content(args) ... end

-- 1. Keep this LOCAL (do not use M.)
local function write_java_file(type, target_dir)
	local def = TYPE_CONFIG[type]
	if not def then
		vim.notify("⛔ Unsupported type: " .. type, vim.log.levels.ERROR)
		return
	end

	-- This input will now run correctly after the picker closes
	local name = vim.fn.input(type .. " Name: ")
	if name == "" then return end
	
	name = name:gsub("%.java$", "")

	local package_path = get_package_from_path(target_dir)
	if not package_path then
		vim.notify("⚠️ Not a standard Java path", vim.log.levels.WARN)
		return
	end

	local content = build_file_content({
		package = package_path,
		name = name,
		def = def,
	})

	local filepath = target_dir:gsub("/$", "") .. "/" .. name .. ".java"
	if vim.fn.filereadable(filepath) == 1 then
		vim.notify("⚠️ File already exists: " .. name .. ".java", vim.log.levels.WARN)
		return
	end

	vim.fn.writefile(content, filepath)
	vim.cmd("edit " .. filepath)
end

-- Helper: Shorten path
local function shorten_path(path)
  local segments = {}
  for s in path:gmatch("[^/]+") do table.insert(segments, s) end
  if #segments <= 2 then return path end
  return segments[1] .. "/.../" .. segments[#segments-1] .. "/" .. segments[#segments]
end

function M.create_java_file(type)
  local pick = require("pick")
  
  -- 1. Determine the Real Filesystem Path
  local cwd = nil
  local buf_name = vim.api.nvim_buf_get_name(0)
  
  -- Check if we are inside an Oil buffer (starts with "oil://")
  if buf_name:match("^oil://") then
    -- Strip "oil://" and any query params to get real path
    cwd = buf_name:gsub("^oil://", ""):gsub("%?.*$", "")
    -- Decode URL encoding if present (e.g., %20 for space)
    cwd = vim.fn.substitute(cwd, "%(%x%x)", [[printf("%c", str2nr(submatch(0), 16))]], "g")
  else
    -- Normal file: get directory of current file
    cwd = vim.fn.expand('%:p:h')
    if cwd == "" or cwd == "." then
      cwd = vim.fn.getcwd()
    end
  end

  -- 2. Find Project Root
  local root = vim.fs.root(cwd, {"pom.xml", "build.gradle", "mvnw", "gradlew"})
  
  if not root then
    root = cwd
    vim.notify("⚠️ No project root found.", vim.log.levels.WARN)
  end

  local search_path = root .. '/src/main/java'
  
  if vim.fn.isdirectory(search_path) == 0 then
    vim.notify("⛔ Directory not found: " .. search_path, vim.log.levels.ERROR)
    return
  end

  local dirs = vim.fn.globpath(search_path, '**/', 0, 1)
  if #dirs == 0 then
    vim.notify("⚠️ No Java packages found.", vim.log.levels.WARN)
    return
  end

  -- 3. Prepare Items
  local items = vim.tbl_map(function(d)
    return { text = shorten_path(d), path = d }
  end, dirs)

  -- 4. Start Picker
  pick.start({
    source = {
      items = items,
      choose = function(item)
        vim.schedule(function()
          write_java_file(type, item.path)
        end)
      end,
    },
    window = { prompt_prefix = "Select Dir> " },
  })
end

return M   
