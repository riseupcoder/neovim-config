local equinox_launcher_path = vim.fn.glob("$HOME/.local/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")

local config_path = vim.fn.glob("$HOME/.local/share/java/jdtls/config_linux")

local lombok_path = vim.fn.glob("$HOME/.local/share/java/lombok.jar")

local jdtls = require("jdtls")

-- local extendedClientCapabilities = jdtls.extendedClientCapabilities
-- extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- local bundles = {}
-- vim.list_extend(bundles, vim.fn.globpath("$HOME/.local/share/java-test", "*.jar", true, true))

-- vim.list_extend(
--	bundles,
--	vim.fn.globpath("$HOME/.local/share/java-debug-adapter", "com.microsoft.java.debug.plugin-*.jar", true, true)
--)

local config = {
	cmd = {
		"java", 
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Xms400M",
		"-Xmx400M",
		"-XX:-ZUncommit",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
 		"-javaagent:" .. lombok_path,
		"-jar",
		equinox_launcher_path,

		"-configuration",
		config_path,

		"-data",
		vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
	},

	root_dir = require("jdtls.setup").find_root({
		".git",
		"mvnw",
		"gradlew",
		"pom.xml",
		"build.gradle",
	}),

	settings = {
		java = {
			server = { launchMode = "Hybrid" },
			extendedClientCapabilities = extendedClientCapabilities,
			eclipse = {
				downloadSources = true,
			},

                compile = {
                        nullAnalysis = {
                           nonnull = { "org.eclipse.jdt.annotation.NonNull", "javax.annotation.Nonnull", "org.jspecify.annotations.NonNull" },
                            nullable = { "org.eclipse.jdt.annotation.Nullable", "javax.annotation.Nullable", "org.jspecify.annotations.Nullable" },
                            nonnullbydefault = { "org.eclipse.jdt.annotation.NonNullByDefault", "org.jspecify.annotations.NullMarked" },
                          ['mode'] = "automatic"
                        },
                 },

			import = {
      				enabled = true,
      				onDemand = {
       				    maxTypes = 10000,
      				},
      				cleanup = {
        				unusedImports = true,
      				},
    			},
			format = {
				enabled = false,
			},
			gradle = {
				enabled = true,
			},
			maven = {
				downloadSources = true,
			},

			references = {
				includeDecompiledSources = false,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referenceCodeLens = {
				enabled = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			},
			signatureHelp = {
				enabled = true,
				description = {
					enabled = true,
				},
			},
			contentProvider = { preferred = "fernflower" }, -- Use fernflower to decompile library code

			-- Specify any completion options
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
					"org.eclipse.jdt.annotation.NonNull",
                                        "org.eclipse.jdt.annotation.Nullable",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
                            
                                -- Enable smart argument guessing (IntelliJ style)
     			 	guessMethodArguments = "insertBestGuessedArguments",
      
                               -- Enable chain completion (e.g., completing .getName() after .getAddress())
                               chain = "enabled", 
			},
			-- How code generation should act
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				hashCodeEquals = {
					useJava7Objects = true,
				},
				useBlocks = true,
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
		},
		redhat = { telemetry = { enabled = false } },
	},

	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
--	init_options = {
--		bundles = bundles,
--		extendedClientCapabilities = extendedClientCapabilities,
--	},
}
-- Keymaps
config.on_attach = function(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, nowait = true })
  end

  map("n", "<leader>Jo", jdtls.organize_imports, "Organize Imports")
  map("n", "<leader>Jc", "<Cmd>JdtCompile<CR>", "Compile Java")
  map("n", "<leader>JC", jdtls.extract_constant, "Extract Constant")
  map("n", "<leader>Jv", jdtls.extract_variable, "Extract Variable")
  map("n", "<leader>Jt", jdtls.test_nearest_method, "Test Method")
  map("v", "<leader>Jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method")

  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)

  vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = bufnr,
  callback = function()
    vim.lsp.buf.format()
  end,
})

  vim.api.nvim_create_autocmd("BufWritePost", {
    buffer = bufnr,
    callback = function()
      vim.lsp.codelens.enable(false, { bufnr = bufnr })
    end,
  })   
end

-- Start or attach to jdtls
require("jdtls").start_or_attach(config)
