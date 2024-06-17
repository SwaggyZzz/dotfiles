return function()
  local configs = require "nvchad.configs.lspconfig"

  configs.defaults()

  function disabled_vtsls_format(dir)
    if string.match(dir, "saas|motor%-design|ad_match_mono|blitz") then
      return true
    else
      return false
    end
  end

  local lspconfig = require "lspconfig"
  local servers = {
    bashls = {},
    jsonls = {},
    yamlls = {},
    lua_ls = {},
    --- FE ---
    -- tsserver = {},
    vtsls = {},
    html = {},
    cssls = {},
    cssmodules_ls = {},
    tailwindcss = {},
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
    --- -- ---
  }

  local common_opts = {
    on_init = configs.on_init,
    on_attach = function(client, bufnr)
      if client.name == "vtsls" and disabled_vtsls_format(client.root_dir) then
        client.server_capabilities.documentFormattingProvider = false
      end
      configs.on_attach(client, bufnr)
    end,
    capabilities = configs.capabilities,
  }

  local function setup(server)
    local server_opts = servers[server]
    -- local setup = server_opts["setup"]

    local opts = vim.tbl_deep_extend("force", common_opts, server_opts)
    lspconfig[server].setup(opts)

    -- if not setup then

    -- elseif type(setup) == "function" then
    --   setup(server_opts)
    -- elseif type(setup) == "table" then
    --   lspconfig[server].setup(vim.tbl_deep_extend("force", server_opts, setup))
    -- else
    --   vim.notify(
    --     string.format(
    --       "Failed to setup [%s].\n\nServer definition under `completion/servers` must return\neither a fun(opts) or a table (got '%s' instead)",
    --       server,
    --       type(custom_handler)
    --     ),
    --     vim.log.levels.ERROR,
    --     { title = "nvim-lspconfig" }
    --   )
    -- end
  end

  local have_mason, mlsp = pcall(require, "mason-lspconfig")
  local all_mslp_servers = {}
  if have_mason then
    all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
  end

  local ensure_installed = {}

  for server, _ in pairs(servers) do
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
