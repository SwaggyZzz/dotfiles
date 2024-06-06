---@diagnostic disable: undefined-field
local M = {}
local map = vim.keymap.set

function M.on_attach(client, bufnr)
  -- if client.supports_method("textDocument/inlayHint") then
  --   local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
  --   if type(ih) == "function" then
  --     ih(buf, value)
  --   elseif type(ih) == "table" and ih.enable then
  --     if value == nil then
  --       value = not ih.is_enabled({ bufnr = buf or 0 })
  --     end
  --     ih.enable(true, { bufnr = bufnr })
  --   end
  -- end

  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,
    opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "K", vim.lsp.buf.hover, opts "Hover")
  map("n", "gK", vim.lsp.buf.signature_help, opts "Show signature help")

  -- map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  -- map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
  -- map("n", "<leader>wl", function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, opts "List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

  -- map("n", "<leader>ra", function()
  --   require "nvchad.lsp.renamer" ()
  -- end, opts "NvRenamer")

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")

  -- setup signature popup
  -- if conf.signature and client.server_capabilities.signatureHelpProvider then
  --   require("nvchad.lsp.signature").setup(client, bufnr)
  -- end
end

function M.common_capabilities()
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    return cmp_nvim_lsp.default_capabilities()
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }

  return capabilities
end

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: lsp.Client):boolean}

---@param opts? lsp.Client.filter
function M.get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  ret = vim.lsp.get_clients(opts)
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

function M.diagnostics_setup()
  local icons = {
    diagnostics = require("utils.icons").get("diagnostics")
  }
  local opts = {
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
      -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
      -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
      -- prefix = "icons",
    },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
      },
    },
  }

  for severity, icon in pairs(opts.signs.text) do
    local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end

  if opts.virtual_text.prefix == "icons" then
    opts.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
        or function(diagnostic)
          for d, icon in pairs(icons.diagnostics) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
        end
  end

  vim.diagnostic.config(vim.deepcopy(opts))
end

function M.inlay_hint_setup()

end

return M
