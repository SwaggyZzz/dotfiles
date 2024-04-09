return {
  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    -- init = function()
    -- 	local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- 	keys[#keys + 1] = {
    -- 		"gd",
    -- 		function()
    -- 			-- DO NOT RESUSE WINDOW
    -- 			require("telescope.builtin").lsp_definitions({ reuse_win = false })
    -- 		end,
    -- 		desc = "Goto Definition",
    -- 		has = "definition",
    -- 	}
    -- end,
    opts = {
      inlay_hints = { enabled = false },
      ---@type lspconfig.options
      servers = {
        html = {},
        cssmodules_ls = {},
        cssls = {},
        tailwindcss = {
          -- root_dir = function(...)
          -- 	return require("lspconfig.util").root_pattern(".git")(...)
          -- end,
        },
        tsserver = {
          -- root_dir = function(...)
          -- 	return require("lspconfig.util").root_pattern(".git")(...)
          -- end,
          -- single_file_support = false,
          -- settings = {
          -- 	typescript = {
          -- 		inlayHints = {
          -- 			includeInlayParameterNameHints = "literal",
          -- 			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          -- 			includeInlayFunctionParameterTypeHints = true,
          -- 			includeInlayVariableTypeHints = false,
          -- 			includeInlayPropertyDeclarationTypeHints = true,
          -- 			includeInlayFunctionLikeReturnTypeHints = true,
          -- 			includeInlayEnumMemberValueHints = true,
          -- 		},
          -- 	},
          -- 	javascript = {
          -- 		inlayHints = {
          -- 			includeInlayParameterNameHints = "all",
          -- 			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          -- 			includeInlayFunctionParameterTypeHints = true,
          -- 			includeInlayVariableTypeHints = true,
          -- 			includeInlayPropertyDeclarationTypeHints = true,
          -- 			includeInlayFunctionLikeReturnTypeHints = true,
          -- 			includeInlayEnumMemberValueHints = true,
          -- 		},
          -- 	},
          -- },
        },
        eslint = {
          settings = {
            codeAction = {
              disableRuleComment = {
                enable = true,
                location = "separateLine",
              },
              showDocumentation = {
                enable = true,
              },
            },
            codeActionOnSave = {
              enable = false,
              mode = "all",
            },
            format = true,
            nodePath = "",
            onIgnoredFiles = "off",
            packageManager = "npm", -- 'npm' | 'yarn' | 'pnpm'
            quiet = false,
            rulesCustomizations = {},
            run = "onType",
            useESLintClass = false,
            validate = "on",
            workingDirectory = {
              -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
              mode = "auto", -- "location" | "auto"
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
      },
      setup = {
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
}
