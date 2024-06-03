return function(opts)
  local lsp_utils = require("utils.lsp")
  local format_utils = require("utils.format")
  
  local formatter = lsp_utils.formatter({
    name = "eslint: lsp",
    primary = false,
    priority = 200,
    filter = "eslint",
  })
  format_utils.register(formatter)

  require("lspconfig").eslint.setup(vim.tbl_deep_extend("force", opts, {
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
  }))
end
