return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    config = require("configs.ui.catppuccin"),
  },
  {
    "nvimdev/dashboard-nvim",
    lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
    config = require("configs.ui.dashboard"),
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    config = require("configs.ui.bufferline"),
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          use_treesitter = true,
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "┌",
            left_bottom = "└",
            right_arrow = "─",
          },
          style = "#737aa2",
        },
        indent = {
          enable = true,
          use_treesitter = true,
          chars = {
            "│",
            "¦",
            "┆",
            "┊",
          },
          style = {
            vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
          },
        },
      })
    end,
  },
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   lazy = true,
  --   main = "ibl",
  --   event = { "CursorHold", "CursorHoldI" },
  --   opts = {
  --     indent = {
  --       char = "│",
  --       tab_char = "│",
  --     },
  --     scope = {
  --       enabled = true,
  --       char = "┃",
  --       show_start = false,
  --       show_end = false,
  --       include = {
  --         node_type = {
  --           ["*"] = {
  --             "argument_list",
  --             "arguments",
  --             "assignment_statement",
  --             "Block",
  --             "class",
  --             "ContainerDecl",
  --             "dictionary",
  --             "do_block",
  --             "do_statement",
  --             "element",
  --             "except",
  --             "FnCallArguments",
  --             "for",
  --             "for_statement",
  --             "function",
  --             "function_declaration",
  --             "function_definition",
  --             "if_statement",
  --             "IfExpr",
  --             "IfStatement",
  --             "import",
  --             "InitList",
  --             "list_literal",
  --             "method",
  --             "object",
  --             "ParamDeclList",
  --             "repeat_statement",
  --             "selector",
  --             "SwitchExpr",
  --             "table",
  --             "table_constructor",
  --             "try",
  --             "tuple",
  --             "type",
  --             "var",
  --             "while",
  --             "while_statement",
  --             "with",
  --           },
  --         },
  --       },
  --     },
  --     exclude = {
  --       filetypes = {
  --         "", -- for all buffers without a file type
  --         "help",
  --         "alpha",
  --         "dashboard",
  --         "neo-tree",
  --         "Trouble",
  --         "trouble",
  --         "lazy",
  --         "mason",
  --         "notify",
  --         "toggleterm",
  --         "lazyterm",
  --         "NvimTree",
  --         "fugitive",
  --         "git",
  --         "gitcommit",
  --         "help",
  --         "json",
  --         "log",
  --         "markdown",
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     local hooks = require("ibl.hooks")
  --     hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
  --     require("ibl").setup(opts)
  --   end,
  -- },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = false,
        },
        signature = {
          enabled = false,
        },
        hover = {
          enabled = false,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      stages = "static",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
  {
    "gen740/SmoothCursor.nvim",
    event = "VeryLazy",
    config = function()
      require("smoothcursor").setup({
        type = "default",
        fancy = {
          enable = true, -- enable fancy mode
          -- head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil }, -- false to disable fancy head
          head = { cursor = "👉", texthl = "SmoothCursor", linehl = nil }, -- false to disable fancy head
          body = {
            { cursor = "󰝥", texthl = "SmoothCursorRed" },
            { cursor = "󰝥", texthl = "SmoothCursorOrange" },
            { cursor = "●", texthl = "SmoothCursorYellow" },
            { cursor = "●", texthl = "SmoothCursorGreen" },
            { cursor = "•", texthl = "SmoothCursorAqua" },
            { cursor = ".", texthl = "SmoothCursorBlue" },
            { cursor = ".", texthl = "SmoothCursorPurple" },
          },
          tail = { cursor = nil, texthl = "SmoothCursor" }, -- false to disable fancy tail
        },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = require("configs.tools.gitsigns"),
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = require("configs.ui.lualine"),
  },
}
