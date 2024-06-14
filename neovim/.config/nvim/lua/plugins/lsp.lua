return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
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
      },
      inlay_hints = {
        enabled = true,
        exclude = { "typescriptreact" }, -- filetypes for which you don't want to enable inlay hints
      },
      setup = {
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            vim.notify(client.name)
            if client.name == "vtsls" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "VeryLazy",
  -- }
}
