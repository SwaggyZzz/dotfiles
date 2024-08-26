return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      ensure_installed = {
        "stylua",
        "prettier",
        "shfmt",
        "goimports",
        "gofumpt",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          vim.api.nvim_exec_autocmds("FileType", {
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
    "neovim/nvim-lspconfig",
    lazy = true,
    -- event = { "CursorHold", "CursorHoldI" }, -- 用这个事件需要手动触发 lsp vim.api.nvim_command([[LspStart]])
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local icons = require("utils.icons")

      -- import lspconfig plugin
      local lspconfig = require("lspconfig")

      -- import mason_lspconfig plugin
      local mason_lspconfig = require("mason-lspconfig")

      -- import cmp-nvim-lsp plugin
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {}
      )
      -- nvim-ufo need config
      -- capabilities.textDocument.foldingRange = {
      --   dynamicRegistration = false,
      --   lineFoldingOnly = true,
      -- }

      -- Change the Diagnostic symbols in the sign column (gutter)
      local signs = {
        Error = icons.diagnostics.BoldError,
        Warn = icons.diagnostics.BoldWarning,
        Hint = icons.diagnostics.BoldHint,
        Info = icons.diagnostics.BoldInformation,
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      })

      local eslint_format_dir = require("core.settings").eslint_format_dir
      local disabled_vtsls_format = function(dir)
        for _, d in ipairs(eslint_format_dir) do
          if dir and string.match(dir, d) then
            return true
          end
        end
        return false
      end

      local map = vim.keymap.set
      local server_opts = {
        on_attach = function(client, bufnr)
          if client.name == "vtsls" and disabled_vtsls_format(client.root_dir) then
            client.server_capabilities.documentFormattingProvider = false
          end

          -- if client.server_capabilities.inlayHintProvider and client.name ~= "vtsls" then
          --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          -- end

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = bufnr, silent = true }

          opts.desc = "LSP Go to definition"
          map("n", "gd", "<CMD>Telescope lsp_definitions<CR>", opts)

          opts.desc = "LSP Go to declaration"
          map("n", "gD", vim.lsp.buf.declaration, opts)

          opts.desc = "LSP Show references"
          map("n", "gR", "<CMD>Telescope lsp_references<cr>", opts)

          opts.desc = "LSP Go to implementation"
          map("n", "gi", vim.lsp.buf.implementation, opts)

          opts.desc = "LSP Go to type definitions"
          map("n", "gt", "<CMD>Telescope lsp_type_definitions<CR>", opts)

          opts.desc = "LSP Code Action"
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

          opts.desc = "LSP Rename"
          map({ "n", "v" }, "<leader>rn", vim.lsp.buf.rename, opts)

          opts.desc = "LSP Show buffer diagnostics"
          map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

          opts.desc = "LSP Show line diagnostics"
          map("n", "<leader>d", vim.diagnostic.open_float, opts)

          opts.desc = "LSP Go to previous diagnostic"
          map("n", "[d", vim.diagnostic.goto_prev, opts)

          opts.desc = "LSP Go to next diagnostic"
          map("n", "]d", vim.diagnostic.goto_next, opts)

          opts.desc = "LSP Show documentation"
          map("n", "K", vim.lsp.buf.hover, opts)

          opts.desc = "LSP Restart"
          map("n", "<leader>rs", ":LspRestart<CR>", opts)
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

      local servers = require("core.settings").lsp_servers
      mason_lspconfig.setup({
        ensure_installed = servers,
        handlers = { setup },
      })

      -- require("ufo").setup({
      --   provider_selector = function(bufnr, filetype, buftype)
      --     local lsp_clients = vim.lsp.get_clients({
      --       bufnr = bufnr,
      --     })
      --     if #lsp_clients > 0 then
      --       return { "lsp", "treesitter" }
      --     end

      --     return { "treesitter", "indent" }
      --   end,
      --   close_fold_kinds_for_ft = {
      --     default = { "imports" },
      --     -- default = { "imports", "comment" },
      --   },
      --   fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      --     local newVirtText = {}
      --     local suffix = (" 󰁂 %d "):format(endLnum - lnum)
      --     local sufWidth = vim.fn.strdisplaywidth(suffix)
      --     local targetWidth = width - sufWidth
      --     local curWidth = 0

      --     for _, chunk in ipairs(virtText) do
      --       local chunkText = chunk[1]
      --       local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      --       if targetWidth > curWidth + chunkWidth then
      --         table.insert(newVirtText, chunk)
      --       else
      --         chunkText = truncate(chunkText, targetWidth - curWidth)
      --         local hlGroup = chunk[2]
      --         table.insert(newVirtText, { chunkText, hlGroup })
      --         chunkWidth = vim.fn.strdisplaywidth(chunkText)
      --         -- str width returned from truncate() may less than 2nd argument, need padding
      --         if curWidth + chunkWidth < targetWidth then
      --           suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      --         end
      --         break
      --       end
      --       curWidth = curWidth + chunkWidth
      --     end

      --     table.insert(newVirtText, { suffix, "MoreMsg" })

      --     return newVirtText
      --   end,
      -- })
    end,
  },
}
