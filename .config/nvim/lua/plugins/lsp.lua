local function get_mason_ensure_installed()
  local settings = require 'core.settings'
  local ensure_installed = {}
  local fmt_servers = {
    'stylua',
    'prettier',
    'eslint_d',
    'shfmt',
    'goimports',
    'gofumpt',
  }

  vim.list_extend(ensure_installed, settings.lsp_servers)
  vim.list_extend(ensure_installed, fmt_servers)

  return ensure_installed
end

local mason_opts = {
  ui = {
    border = 'rounded',
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
  },
}

return {
  {
    'mason-org/mason.nvim',
    lazy = false,
    opts = mason_opts,
  },
  {
    'mason-org/mason-lspconfig.nvim',
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    lazy = false,
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    opts = function()
      return {
        ensure_installed = get_mason_ensure_installed(),
        run_on_start = true,
        start_delay = 0,
      }
    end,
    config = function(_, opts)
      local mason_tool_installer = require 'mason-tool-installer'
      mason_tool_installer.setup(opts)

      -- 正常启动由插件的 VimEnter autocmd 触发；若插件在 VimEnter 后才加载，
      -- 则在这里补跑一次。失败后不设置防抖，下次启动会继续补装缺失工具。
      if vim.v.vim_did_enter == 1 then
        mason_tool_installer.run_on_start()
      end
    end,
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mason-org/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      local icons = require 'core.icons'
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        update_in_insert = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.Hint,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.Information,
          },
        },
        virtual_text = {
          prefix = '◍',
          -- prefix = '●',
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_blink, blink_cmp = pcall(require, 'blink.cmp')
      if has_blink then
        capabilities = vim.tbl_deep_extend('force', capabilities, blink_cmp.get_lsp_capabilities({}, false))
      end
      capabilities = vim.tbl_deep_extend('force', capabilities, {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      })

      -- nvim-ufo need config
      -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local eslint_format_dir = require('core.settings').eslint_format_dir
      local disabled_tsgo_format = function(dir)
        for _, d in ipairs(eslint_format_dir) do
          if dir and string.match(dir, d) then
            return true
          end
        end
        return false
      end

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local lsp_servers = require('core.settings').lsp_servers

      local server_opts = {
        on_attach = function(client, bufnr)
          if client.name == 'tsgo' and disabled_tsgo_format(client.root_dir) then
            client.server_capabilities.documentFormattingProvider = false
          end

          -- if client.server_capabilities.inlayHintProvider and client.name ~= 'tsgo' and client.name ~= 'lua_ls' then
          --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          -- end

          vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'LSP Line Diagnostics' })
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'LSP Go to previous diagnostic' })
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'LSP Go to next diagnostic' })
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { silent = true, desc = 'LSP Code Action' })
          vim.keymap.set({ 'n' }, 'gK', vim.lsp.buf.signature_help, { silent = true, desc = 'LSP Show Signature' })
          vim.keymap.set({ 'i' }, '<C-k>', vim.lsp.buf.signature_help, { silent = true, desc = 'LSP Show Signature' })
          -- vim.keymap.set({ 'n' }, 'K', function()
          --   local winid = require('ufo').peekFoldedLinesUnderCursor()
          --   if not winid then
          --     vim.lsp.buf.hover()
          --   end
          -- end, { silent = true, desc = 'LSP Show documentation' })
        end,
        capabilities = capabilities,
      }

      for _, server_name in ipairs(lsp_servers) do
        if server_name ~= 'rust_analyzer' then
          local ok, custom_handler = pcall(require, 'configs.lsp.' .. server_name)
          if not ok then
            vim.lsp.config(server_name, server_opts)
          elseif type(custom_handler) == 'function' then
            local custom_server_opts = custom_handler(server_opts)
            vim.lsp.config(server_name, custom_server_opts)
          elseif type(custom_handler) == 'table' then
            vim.lsp.config(server_name, vim.tbl_deep_extend('force', server_opts, custom_handler))
          else
            vim.notify(
              string.format(
                "Failed to setup [%s].\n\nServer definition under `completion/servers` must return\neither a fun(opts) or a table (got '%s' instead)",
                server_name,
                type(custom_handler)
              ),
              vim.log.levels.ERROR,
              { title = 'nvim-lspconfig' }
            )
            return
          end

          vim.lsp.enable(server_name)
        end
      end

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- 安装由 mason-tool-installer 统一处理
        automatic_enable = false,
      }
    end,
  },
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}
