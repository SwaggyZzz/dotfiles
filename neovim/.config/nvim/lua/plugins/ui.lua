return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "catppuccin/nvim",
    lazy = false,
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
    "lukas-reineke/indent-blankline.nvim",
    lazy = true,
    main = "ibl",
    event = { "CursorHold", "CursorHoldI" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        char = "┃",
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "", -- for all buffers without a file type
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "NvimTree",
          "fugitive",
          "git",
          "gitcommit",
          "help",
          "json",
          "log",
          "markdown",
        },
      },
    },
    config = function(_, opts)
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = true,
        },
        hover = {
          enabled = true,
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
    "lewis6991/gitsigns.nvim",
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("configs.tools.gitsigns"),
  },
  {
    "sontungexpt/sttusline",
    branch = "table_version",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = { "BufEnter" },
    opts = {
      statusline_color = "StatusLine",
      disabled = {
        filetypes = {
          "NeoTree",
          "NvimTree",
          "lazy",
        },
        buftypes = {
          "terminal",
        },
      },
      components = {
        {
          "mode",
          -- {
          --   separator = {
          --     left = " ",
          --   },
          -- },
        },
        "os-uname",
        "filename",
        "filesize",
        "git-branch",
        "git-diff",
        "%=",
        "diagnostics",
        "lsps-formatters",
        "indent",
        "encoding",
        "pos-cursor",
        -- "pos-cursor-progress",
      },
    },
  },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "meuter/lualine-so-fancy.nvim",
  --   },
  --   opts = function()
  --     return {
  --       options = {
  --         theme = "catppuccin",
  --         -- component_separators = { left = "│", right = "│" },
  --         -- section_separators = { left = "", right = "" },
  --         component_separators = "",
  --         section_separators = { left = "", right = "" },
  --         globalstatus = true,
  --         refresh = {
  --           statusline = 100,
  --         },
  --       },
  --       sections = {
  --         lualine_a = {
  --           { "fancy_mode", width = 6 },
  --         },
  --         lualine_b = {
  --           { "fancy_branch" },
  --           { "fancy_diff" },
  --         },
  --         lualine_c = {
  --           { "fancy_cwd", substitute_home = true },
  --         },
  --         lualine_x = {
  --           { "fancy_diagnostics" },
  --           { "fancy_searchcount" },
  --           { "fancy_location" },
  --         },
  --         lualine_y = {
  --           { "fancy_filetype", ts_icon = "" },
  --         },
  --         lualine_z = {
  --           { "fancy_lsp_servers", split = "|" },
  --         },
  --       },
  --       extensions = { "nvim-tree", "neo-tree", "lazy", "quickfix", "trouble" },
  --     }
  --   end,
  -- },
}
