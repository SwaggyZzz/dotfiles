return function(origin_opts)
  local lspconfig = require("lspconfig")
  local util = require("lspconfig.util")

  local server_opts = vim.tbl_deep_extend("force", origin_opts, {
    -- on_attach = function(client, bufnr)
    --   origin_opts.on_attach(client, bufnr)
    --
    --   local map = vim.keymap.set
    --
    --   local function opts(desc)
    --     return { buffer = bufnr, desc = "LSP " .. desc }
    --   end
    --
    --   map("n", "gD", function()
    --     require("vtsls").commands.goto_source_definition(0)
    --   end, opts("Go to declaration"))
    --
    --   map("n", "<Leader>co", function()
    --     require("vtsls").commands.organize_imports(0)
    --   end, opts("Organize Imports"))
    --
    --   map("n", "<Leader>cM", function()
    --     require("vtsls").commands.add_missing_imports(0)
    --   end, opts("Add missing imports"))
    --
    --   map("n", "gR", function()
    --     require("vtsls").commands.file_references(0)
    --   end, opts("File References"))
    -- end,

    root_dir = function(fname)
      return util.root_pattern("tsconfig.json", "jsconfig.json")(fname)
        or util.root_pattern("package.json", ".git")(fname)
    end,
    single_file_support = true,
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
      javascript = {
        updateImportsOnFileMove = {
          enabled = "always",
        },
      },
    },
  })

  lspconfig["vtsls"].setup(server_opts)
end
