return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      {
        "hrsh7th/cmp-cmdline",
        keys = { ":", "/", "?" },
        dependencies = { "hrsh7th/nvim-cmp" },
        config = function(_, opts)
          local cmp = require("cmp")
          cmp.setup(opts)
          cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = "buffer" },
            },
          })
          cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = "path" },
              { name = "cmdline" },
            }),
          })
        end,
      },
      {
        "saadparwaiz1/cmp_luasnip",
        dependencies = {
          {
            -- snippet plugin
            "L3MON4D3/LuaSnip",
            build = "make install_jsregexp",
            dependencies = "rafamadriz/friendly-snippets",
            opts = { history = true, updateevents = "TextChanged,TextChangedI" },
            config = function(_, opts)
              require("luasnip").config.set_config(opts)
              -- vscode format
              require("luasnip.loaders.from_vscode").lazy_load()

              -- lua format
              require("luasnip.loaders.from_lua").load()
            end,
          },
        },
      },
      -- tailwindcss
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local icons = require("core.icons")

      local format = function(entry, item)
        local icon = icons.kind[item.kind] or " "

        if entry.source.name == "copilot" then
          icon = icons.git.Octoface
          item.kind_hl_group = "CmpItemKindCopilot"
        end

        if entry.source.name == "cmp_tabnine" then
          icon = icons.misc.Robot
          item.kind_hl_group = "CmpItemKindTabnine"
        end

        if entry.source.name == "crates" then
          icon = icons.misc.Package
          item.kind_hl_group = "CmpItemKindCrate"
        end

        if entry.source.name == "lab.quick_data" then
          icon = icons.misc.CircuitBoard
          item.kind_hl_group = "CmpItemKindConstant"
        end

        if entry.source.name == "emoji" then
          icon = icons.misc.Smiley
          item.kind_hl_group = "CmpItemKindEmoji"
        end

        icon = (" " .. icon .. " ")
        item.kind = string.format("%s %s", icon, item.kind)

        return item
      end

      local buffer_option = {
        -- Complete from all visible buffers (splits)
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      }

      local auto_select = true
      local defaults = require("cmp.config.default")()

      cmp.setup({
        experimental = {
          ghost_text = false,
        },
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = {
            scrollbar = false,
            border = {
              { "󱐋", "WarningMsg" },
              { "─", "Comment" },
              { "╮", "Comment" },
              { "│", "Comment" },
              { "╯", "Comment" },
              { "─", "Comment" },
              { "╰", "Comment" },
              { "│", "Comment" },
            },
          },
          documentation = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
            border = {
              { "", "DiagnosticHint" },
              { "─", "Comment" },
              { "╮", "Comment" },
              { "│", "Comment" },
              { "╯", "Comment" },
              { "─", "Comment" },
              { "╰", "Comment" },
              { "│", "Comment" },
            },
          },
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            format(entry, item)
            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          -- ["<CR>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     if luasnip.expandable() then
          --       luasnip.expand()
          --     else
          --       cmp.confirm({
          --         select = true,
          --       })
          --     end
          --   else
          --     fallback()
          --   end
          -- end),

          -- ["<CR>"] = cmp.mapping({
          --   i = function(fallback)
          --     if cmp.visible() and cmp.get_active_entry() then
          --       cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          --     else
          --       fallback()
          --     end
          --   end,
          --   s = cmp.mapping.confirm({ select = true }),
          --   c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
          -- }),

          ["<CR>"] = function(fallback)
            if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
              require("utils").create_undo()
              if
                cmp.confirm({
                  select = true,
                  behavior = cmp.ConfirmBehavior.Insert,
                })
              then
                return
              end
            end
            return fallback()
          end,
          ["<S-CR>"] = function(fallback)
            if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
              require("utils").create_undo()
              if
                cmp.confirm({
                  select = true,
                  behavior = cmp.ConfirmBehavior.Replace,
                })
              then
                return
              end
            end
            return fallback()
          end, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          -- { name = "luasnip" },
          { name = "buffer", keyword_length = 3, max_item_count = 10, option = buffer_option },
          { name = "nvim_lua" },
          { name = "path" },
        }),
        sorting = defaults.sorting,
      })
    end,
  },
}
