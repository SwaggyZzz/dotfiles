return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      transparent_background = true,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      }
      return opts
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      -- https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=Swaggy%20Z
      local logo = [[

███████╗██╗    ██╗ █████╗  ██████╗  ██████╗██╗   ██╗    ███████╗
██╔════╝██║    ██║██╔══██╗██╔════╝ ██╔════╝╚██╗ ██╔╝    ╚══███╔╝
███████╗██║ █╗ ██║███████║██║  ███╗██║  ███╗╚████╔╝       ███╔╝
╚════██║██║███╗██║██╔══██║██║   ██║██║   ██║ ╚██╔╝       ███╔╝
███████║╚███╔███╔╝██║  ██║╚██████╔╝╚██████╔╝  ██║       ███████╗
╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝   ╚═╝       ╚══════╝


      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<S-h>", false },
      { "<S-l>", false },
      { "[b", false },
      { "]b", false },
      { "<A-S-h>", "<CMD>BufferLineMovePrev<CR>" },
      { "<A-S-l>", "<CMD>BufferLineMoveNext<CR>" },
      { "<Leader>1", "<CMD>BufferLineGoToBuffer 1<CR>" },
      { "<Leader>2", "<CMD>BufferLineGoToBuffer 2<CR>" },
      { "<Leader>3", "<CMD>BufferLineGoToBuffer 3<CR>" },
      { "<Leader>4", "<CMD>BufferLineGoToBuffer 4<CR>" },
      { "<Leader>5", "<CMD>BufferLineGoToBuffer 5<CR>" },
      { "<Leader>6", "<CMD>BufferLineGoToBuffer 6<CR>" },
      { "<Leader>7", "<CMD>BufferLineGoToBuffer 7<CR>" },
      { "<Leader>8", "<CMD>BufferLineGoToBuffer 8<CR>" },
      { "<Leader>9", "<CMD>BufferLineGoToBuffer 9<CR>" },
    },
    opts = function(_, opts)
      opts.options = {
        always_show_bufferline = true,
        numbers = function(opts)
          return string.format("%s", opts.ordinal)
        end,
      }

      -- if vim.g.colors_name:find("catppuccin") then
      --   -- local cp = require("swaggyz.utils.modules").get_palette() -- Get the palette.
      --
      --   local catppuccin_hl_overwrite = {
      --     highlights = require("catppuccin.groups.integrations.bufferline").get({
      --       styles = { "italic", "bold" },
      --       custom = {
      --         all = {
      --           -- Hint
      --           hint = { fg = "#DC8A78" },
      --           hint_visible = { fg = "#DC8A78" },
      --           hint_selected = { fg = "#DC8A78" },
      --           hint_diagnostic = { fg = "#DC8A78" },
      --           hint_diagnostic_visible = { fg = "#DC8A78" },
      --           hint_diagnostic_selected = { fg = "#DC8A78" },
      --         },
      --       },
      --     }),
      --   }
      --
      --   opts = vim.tbl_deep_extend("force", opts, catppuccin_hl_overwrite)
      -- end
    end,
  },
}
