return {
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

      opts.presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = true, -- add a border to hover docs and signature help
      }

      opts.lsp = {
        signature = {
          enabled = false,
          opts = {
            size = {
              max_width = 50,
            },
          },
        },
        hover = {
          enabled = true,
          opts = {
            size = {
              max_width = 50,
            },
          },
        },
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
    },
    opts = function(_, opts)
      local options = vim.tbl_deep_extend("force", opts.options, {
        always_show_bufferline = true,
        numbers = function(opts)
          return string.format("%s", opts.ordinal)
        end,
      })
      opts.options = options

      if vim.g.colors_name:find("catppuccin") then
        opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
      end
    end,
  },
  {
    "rasulomaroff/reactive.nvim",
    event = "VeryLazy",
    config = function()
      require("reactive").setup({
        load = { "catppuccin-mocha-cursor", "catppuccin-mocha-cursorline" },
      })
    end,
  },
}
