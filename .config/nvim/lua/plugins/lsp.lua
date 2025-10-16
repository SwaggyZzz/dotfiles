return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    build = ':MasonUpdate',
    opts = {
      ui = {
        border = 'rounded',
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
      ensure_installed = {
        'stylua',
        'prettier',
        'shfmt',
        'goimports',
        'gofumpt',
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require 'mason-registry'
      mr:on('package:install:success', function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          vim.api.nvim_exec_autocmds('FileType', {
            buffer = vim.api.nvim_get_current_buf(),
            modeline = false,
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim', branch = 'v1.x' },
      -- { 'saghen/blink.cmp' },
      -- { 'antosha417/nvim-lsp-file-operations', config = true },
      -- { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local icons = require 'core.icons'
      local mason_lspconfig = require 'mason-lspconfig'

      vim.diagnostic.config {
        float = {
          border = 'rounded',
        },
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = 'if_many',
          prefix = '●',
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.BoldError,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.BoldWarning,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.BoldHint,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.BoldInformation,
          },
        },
      }

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
      local disabled_vtsls_format = function(dir)
        for _, d in ipairs(eslint_format_dir) do
          if dir and string.match(dir, d) then
            return true
          end
        end
        return false
      end

      local server_opts = {
        on_attach = function(client, bufnr)
          if client.name == 'vtsls' and disabled_vtsls_format(client.root_dir) then
            client.server_capabilities.documentFormattingProvider = false
          end

          if client.server_capabilities.inlayHintProvider and client.name ~= 'vtsls' then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end

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

      local function setup(server)
        if server == 'rust_analyzer' then
          return
        end
        local ok, custom_handler = pcall(require, 'configs.lsp.servers.' .. server)

        if not ok then
          vim.lsp.config(server, server_opts)
        elseif type(custom_handler) == 'function' then
          local custom_server_opts = custom_handler(server_opts)
          vim.lsp.config(server, custom_server_opts)
        elseif type(custom_handler) == 'table' then
          vim.lsp.config(server, vim.tbl_deep_extend('force', server_opts, custom_handler))
        else
          vim.notify(
            string.format(
              "Failed to setup [%s].\n\nServer definition under `completion/servers` must return\neither a fun(opts) or a table (got '%s' instead)",
              server,
              type(custom_handler)
            ),
            vim.log.levels.ERROR,
            { title = 'nvim-lspconfig' }
          )
          return
        end

        vim.lsp.enable(server)
      end

      local servers = require('core.settings').lsp_servers

      mason_lspconfig.setup {
        ensure_installed = servers,
        handlers = { setup },
      }
    end,
  },
}
