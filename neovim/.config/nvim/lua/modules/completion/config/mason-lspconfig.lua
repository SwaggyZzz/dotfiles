local M = {}

M.setup = function()
  local nvim_lsp = require("lspconfig")
  local mason_lspconfig = require("mason-lspconfig")

  mason_lspconfig.setup({
    ensure_installed = {
      "bashls",
      "html",
      "jsonls",
      "lua_ls",
      "tsserver",
      "cssls",
      "cssmodules_ls",
      "tailwindcss",
      "rust_analyzer",
      "eslint",
      "vuels",
      "yamlls",
      "svelte",
      "gopls",
    },
    automatic_installation = true,
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities() -- 可以不要初始化
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      silent = true,
      border = "rounded",
    }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
    -- ["textDocument/publishDiagnostics"] = vim.lsp.with(
    --   vim.lsp.diagnostic.on_publish_diagnostics,
    --   { virtual_text = true, underline = true }
    -- ),
  }

  local opts = {
    on_attach = function(client, bufnr)
    end,
    handlers = handlers,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150
    }
  }

  ---A handler to setup all servers defined under `config/servers/*.lua`
  ---@param lsp_name string
  local function mason_lsp_handler(lsp_name)
    local ok, custom_handler = pcall(require, "modules.completion.config.servers." .. lsp_name)
    if not ok then
      -- Default to use factory config for server(s) that doesn't include a spec
      nvim_lsp[lsp_name].setup(opts)
      return
    elseif type(custom_handler) == "function" then
      --- Case where language server requires its own setup
      --- Make sure to call require("lspconfig")[lsp_name].setup() in the function
      --- See `clangd.lua` for example.
      custom_handler(opts)
    elseif type(custom_handler) == "table" then
      nvim_lsp[lsp_name].setup(vim.tbl_deep_extend("force", opts, custom_handler))
    else
      vim.notify(
        string.format(
          "Failed to setup [%s].\n\nServer definition under `completion/servers` must return\neither a fun(opts) or a table (got '%s' instead)",
          lsp_name,
          type(custom_handler)
        ),
        vim.log.levels.ERROR,
        { title = "nvim-lspconfig" }
      )
    end
  end

  mason_lspconfig.setup_handlers({ mason_lsp_handler })
end

return M
