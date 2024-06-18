return function()
  local lspconfig = require("lspconfig")
  local servers = require("core.settings").lsp_servers

  local map = vim.keymap.set

  local diagnostic_setup = function()
    local opts = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅙",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "󰌵",
          [vim.diagnostic.severity.INFO] = "󰋼",
        },
      },
    }

    for severity, icon in pairs(opts.signs.text) do
      local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
      name = "DiagnosticSign" .. name
      vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    end

    vim.diagnostic.config(vim.deepcopy(opts))
  end

  local disabled_vtsls_format = function(dir)
    if dir and string.match(dir, "saas|motor%-design|ad_match_mono|blitz") then
      return true
    else
      return false
    end
  end

  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {}
  )

  local server_opts = {
    on_attach = function(client, bufnr)
      if client.name == "vtsls" and disabled_vtsls_format(client.root_dir) then
        client.server_capabilities.documentFormattingProvider = false
      end

      local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
      end

      map("n", "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,
        opts "Go to definition")
      map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
      map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
      map("n", "K", vim.lsp.buf.hover, opts "Hover")
      map("n", "gK", vim.lsp.buf.signature_help, opts "Signature Help")
      map("n", "<c-k>", vim.lsp.buf.signature_help, opts "Signature Help")

      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
      map("n", "gr", "<cmd>Telescope lsp_references<cr>", opts "Show references")

      -- map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
      -- map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

      -- map("n", "<leader>wl", function()
      --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      -- end, opts "List workspace folders")
    end,
    capabilities = capabilities,
  }

  local function setup(server)
    local ok, custom_handler = pcall(require, "configs.lsp.servers." .. server)

    if not ok then
      lspconfig[server].setup(server_opts)
      return
    elseif type(custom_handler) == "function" then
      --- Case where language server requires its own setup
      --- Make sure to call require("lspconfig")[lsp_name].setup() in the function
      custom_handler(server_opts)
    elseif type(custom_handler) == "table" then
      lspconfig[server].setup(vim.tbl_deep_extend("force", server_opts, custom_handler))
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

  diagnostic_setup()
end
