return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
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

          -- snipmate format
          require("luasnip.loaders.from_snipmate").load()

          -- lua format
          require("luasnip.loaders.from_lua").load()
        end,
      },

      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },

      -- tailwindcss
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function()
      local cmp = require("cmp")
      local icons = require("utils.icons")

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

      return {
        experimental = {
          ghost_text = false,
          native_menu = false,
        },
        completion = {
          completeopt = "menu,menuone,noselect",
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
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            format(entry, item)
            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
          end,
        },

        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),

          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer", keyword_length = 5, max_item_count = 10, option = buffer_option },
          { name = "nvim_lua" },
          { name = "path" },
        },
        performance = {
          max_view_entries = 30,
        },
      }
    end,
  },
}
