return function()
  local cmp = require("cmp")
  local defaults = require("cmp.config.default")()

  local icons = {
    kind = require("utils.icons").get("kind"),
    type = require("utils.icons").get("type"),
    cmp = require("utils.icons").get("cmp"),
  }

  local border = function(hl)
    return {
      { "┌", hl },
      { "─", hl },
      { "┐", hl },
      { "│", hl },
      { "┘", hl },
      { "─", hl },
      { "└", hl },
      { "│", hl },
    }
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      completion = {
        border = border("PmenuBorder"),
        winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:PmenuSel",
        scrollbar = false,
      },
      documentation = {
        border = border("CmpDocBorder"),
        winhighlight = "Normal:CmpDoc",
      },
    },
    performance = {
      async_budget = 1,
      max_view_entries = 15,
    },
    sorting = defaults.sorting,
    sources = {
			{ name = "nvim_lsp", max_item_count = 350 },
			{ name = "nvim_lua" },
			{ name = "luasnip" },
			{ name = "path" },
			{
				name = "buffer",
				option = {
					get_bufnrs = function()
						return vim.api.nvim_list_bufs()
					end,
				},
			},
		},
    formatting = {
      fields = { "abbr", "kind", "menu" },
      format = function(entry, item)
        local lspkind_icons = vim.tbl_deep_extend("force", icons.kind, icons.type, icons.cmp)
        item.kind =
            string.format(" %s  %s", lspkind_icons[item.kind] or icons.cmp.undefined, item.kind or "")

        item.menu = setmetatable({
          cmp_tabnine = "[TN]",
          copilot = "[CPLT]",
          buffer = "[BUF]",
          orgmode = "[ORG]",
          nvim_lsp = "[LSP]",
          nvim_lua = "[LUA]",
          path = "[PATH]",
          tmux = "[TMUX]",
          treesitter = "[TS]",
          latex_symbols = "[LTEX]",
          luasnip = "[SNIP]",
          spell = "[SPELL]",
        }, {
          __index = function()
            return "[BTN]" -- builtin/unknown source names
          end,
        })[entry.source.name]

        local label = item.abbr
        local truncated_label = vim.fn.strcharpart(label, 0, 80)
        if truncated_label ~= label then
          item.abbr = truncated_label .. "..."
        end

        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    },
    experimental = {
      ghost_text = {
        hl_group = "Whitespace",
      },
    },
    mapping = cmp.mapping.preset.insert({
      ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-w>"] = cmp.mapping.close(),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_locally_jumpable() then
          require("luasnip").expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
  })
end
