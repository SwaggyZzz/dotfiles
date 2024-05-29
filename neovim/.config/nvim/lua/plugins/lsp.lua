return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local default_capabilities = require("nvchad.configs.lspconfig").capabilities

      return {
        capabilities = vim.tbl_deep_extend(
          "force",
          {},
          default_capabilities,
          has_cmp and cmp_nvim_lsp.default_capabilities() or {}
        ),
        servers = {
          lua_ls = {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
                  },
                  maxPreload = 100000,
                  preloadFileSize = 10000,
                },
              },
            },
          },
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
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
    end,
    config = require "configs.lspconfig",
    dependencies = {
      -- { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      -- { "folke/neodev.nvim",  opts = {} },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          vim.api.nvim_exec_autocmds("FileType", {
            buffer = vim.api.nvim_get_current_buf(),
            modeline = false,
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
