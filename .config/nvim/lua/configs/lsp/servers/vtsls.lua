return function(origin_opts)
  local util = require 'lspconfig.util'

  local server_opts = vim.tbl_deep_extend('force', origin_opts, {
    -- on_attach = function(client, bufnr)
    --   origin_opts.on_attach(client, bufnr)

    --   local map = vim.keymap.set

    --   local function opts(desc)
    --     return { buffer = bufnr, desc = "LSP " .. desc }
    --   end

    --   map("n", "gD", function()
    --     require("vtsls").commands.goto_source_definition(0)
    --   end, opts("Go to declaration"))

    --   map("n", "<Leader>co", function()
    --     require("vtsls").commands.organize_imports(0)
    --   end, opts("Organize Imports"))

    --   map("n", "<Leader>cM", function()
    --     require("vtsls").commands.add_missing_imports(0)
    --   end, opts("Add missing imports"))

    --   map("n", "gR", function()
    --     require("vtsls").commands.file_references(0)
    --   end, opts("File References"))
    -- end,
    root_dir = function(bufnr, on_dir)
      local filename = vim.api.nvim_buf_get_name(bufnr)
      on_dir(util.root_pattern('tsconfig.json', 'jsconfig.json')(filename) or util.root_pattern('package.json', '.git')(filename)) 
    end,
    single_file_support = true,
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = 'always' },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = 'literals' },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
      javascript = {
        updateImportsOnFileMove = {
          enabled = 'always',
        },
      },
    },
  })
 
  return server_opts
end
