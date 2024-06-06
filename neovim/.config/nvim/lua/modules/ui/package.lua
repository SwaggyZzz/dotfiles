packadd({
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  config = require("ui.config.catppuccin"),
})

packadd({
  "nvimdev/dashboard-nvim",
  lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
  config = require("ui.config.dashboard"),
})

packadd({
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "meuter/lualine-so-fancy.nvim",
  },
  opts = function()
    local icons = {
      misc = require("utils.icons").get("misc"),
      ui = require("utils.icons").get("ui"),
      git = require("utils.icons").get("git")
    }
    return {
      options = {
        theme = "catppuccin",
        -- component_separators = { left = "│", right = "│" },
        -- section_separators = { left = "", right = "" },
        component_separators = "",
        section_separators = { left = "", right = "" },
        globalstatus = true,
        refresh = {
          statusline = 100,
        },
      },
      sections = {
        lualine_a = {
          { "fancy_mode", width = 3 },
        },
        lualine_b = {
          { "fancy_branch", icon = { icons.git.Branch } },
          { "fancy_diff" },
        },
        lualine_c = {
          {
            "fancy_cwd",
            icon = { icons.ui.FolderWithHeart, color = { fg = "SkyBlue3" } },
            substitute_home = true
          },
        },
        lualine_x = {
          { "fancy_diagnostics" },
          { "fancy_searchcount" },
          { "fancy_location" },
        },
        lualine_y = {
          {
            "fancy_filetype",
            ts_icon = icons.misc.Tree
          },
        },
        lualine_z = {
          {
            "fancy_lsp_servers",
            split = "|",
            icon = icons.misc.LspAvailable
          },
        },
      },
      extensions = { "nvim-tree", "neo-tree", "lazy", "quickfix", "trouble" },
    }
  end,
})

packadd({
  "lukas-reineke/indent-blankline.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI" },
  opts = {
    debounce = 200,
    whitespace = { remove_blankline_trail = true },
    indent = {
      char = "│",
      tab_char = "│",
    },
    scope = {
      enabled = true,
      char = "┃",
      show_start = false,
      show_end = false
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
  main = "ibl",
})

packadd({
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  after = "catppuccin",
  config = require("ui.config.bufferline"),
})

packadd({
  "rcarriga/nvim-notify",
  lazy = true,
  event = "VeryLazy",
  config = require("ui.config.notify"),
})

packadd({ "nvim-tree/nvim-web-devicons", lazy = true })
packadd({ "MunifTanjim/nui.nvim", lazy = true })

packadd({
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
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
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
    },
  },
})

-- packadd({
--   'rasulomaroff/reactive.nvim',
--   event = "VeryLazy",
--   opts = {
--     load = { "catppuccin-mocha-cursor", "catppuccin-mocha-cursorline" },
--   },
-- })
