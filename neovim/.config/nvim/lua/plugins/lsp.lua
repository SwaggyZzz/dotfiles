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
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
      },
      transparency = 100,
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  }
}
