local baseDefinitionHandler = vim.lsp.handlers["textDocument/definition"]

local filter = require("completion.config.utils.filter").filter
local filterReactDTS = require("completion.config.utils.filterReactDTS").filterReactDTS

-- local mason_registry = require('mason-registry')
-- local tsserver_path = mason_registry.get_package('typescript-language-server'):get_install_path()


local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = "rounded",
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
  ["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { virtual_text = true }
  ),
  ["textDocument/definition"] = function(err, result, method, ...)
    -- P(result)
    if vim.tbl_islist(result) and #result > 1 then
      local filtered_result = filter(result, filterReactDTS)
      return baseDefinitionHandler(err, filtered_result, method, ...)
    end

    baseDefinitionHandler(err, result, method, ...)
  end,
}

local ok, tsserver = pcall(require, "typescript-tools")

if ok then
  tsserver.setup({
    on_attach = function(client, bufnr)
      if vim.fn.has("nvim-0.10") then
        -- Enable inlay hints
        vim.lsp.inlay_hint(bufnr, true)
      end
    end,
    handlers = handlers,
    settings = {
      separate_diagnostic_server = true,
      -- tsserver_path = tsserver_path,
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "all",
        includeCompletionsForModuleExports = true,
        quotePreference = "auto",
      },
      tsserver_plugins = {
        -- for TypeScript v4.9+
        "@styled/typescript-styled-plugin",
        -- or for older TypeScript versions
        -- "typescript-styled-plugin",
      },
    },
  })
end
