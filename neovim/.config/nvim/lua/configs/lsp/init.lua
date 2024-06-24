return function()
  local lspconfig = require("lspconfig")
  local servers = require("core.settings").lsp_servers

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

  -- nvim-ufo need config
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  local server_opts = {
    on_attach = function(client, bufnr)
      if client.name == "vtsls" and disabled_vtsls_format(client.root_dir) then
        client.server_capabilities.documentFormattingProvider = false
      end
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

  require("ufo").setup({
    provider_selector = function(bufnr, filetype, buftype)
      local lsp_clients = vim.lsp.get_clients({
        bufnr = bufnr,
      })
      if #lsp_clients > 0 then
        return { "lsp", "treesitter" }
      end

      return { "treesitter", "indent" }
    end,
    close_fold_kinds_for_ft = {
      default = { "imports", "comment" },
    },
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (" 󰁂 %d "):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0

      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end

      table.insert(newVirtText, { suffix, "MoreMsg" })

      return newVirtText
    end,
  })
end
