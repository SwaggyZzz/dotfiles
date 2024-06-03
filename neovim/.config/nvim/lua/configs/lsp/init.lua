return function()
  local servers = {
    "bashls",
    "jsonls",
    "yamlls",
    "lua_ls",
    --- FE ---
    "tsserver",
    "html",
    "cssls",
    "cssmodules_ls",
    "tailwindcss",
    "eslint",
    --- -- ---
  }


  local format_utils = require("utils.format")
  local lsp_utils = require("utils.lsp")
  format_utils.register(lsp_utils.formatter())

  local lspconfg = require("lspconfig")

  local server_opts = {
    capabilities = lsp_utils.common_capabilities(),
    on_attach = lsp_utils.on_attach,
    on_init = lsp_utils.on_init
  }

  local function setup(server)
    local ok, custom_handler = pcall(require, "configs.lsp.servers." .. server)

    if not ok then
      lspconfg[server].setup(server_opts)
      return
    elseif type(custom_handler) == "function" then
      --- Case where language server requires its own setup
      --- Make sure to call require("lspconfig")[lsp_name].setup() in the function
      --- See `clangd.lua` for example.
      custom_handler(server_opts)
    elseif type(custom_handler) == "table" then
      lspconfg[server].setup(vim.tbl_deep_extend("force", server_opts, custom_handler))
    else
      vim.notify(
        string.format(
          "Failed to setup [%s].\n\nServer definition under `completion/servers` must return\neither a fun(opts) or a table (got '%s' instead)",
          server,
          type(custom_handler)
        ),
        vim.log.levels.ERROR,
        { title = "nvim-lspconfig" }
      )
    end
  end

  local have_mason, mlsp = pcall(require, "mason-lspconfig")
  local all_mslp_servers = {}
  if have_mason then
    all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
  end

  local ensure_installed = {}

  for _, server in pairs(servers) do
    if not vim.tbl_contains(all_mslp_servers, server) then
      setup(server)
    else
      ensure_installed[#ensure_installed + 1] = server
    end
  end

  if have_mason then
    mlsp.setup({
      ensure_installed = ensure_installed,
      handlers = { setup },
    })
  end
end
