return function()
  local mocha = require("catppuccin.palettes").get_palette("mocha")
  local transparent_background = require("core.settings").transparent_background

  local opts = {
    options = {
      -- numbers = "ordinal",
      numbers = function(opts)
        return string.format("%s", opts.raise(opts.ordinal))
      end,
      close_command = "BufDel! %d",
      right_mouse_command = "BufDel! %d",
      color_icons = true,
      always_show_bufferline = false,
      show_buffer_close_icons = false,
      diagnostics = false,
      -- diagnostics = "nvim_lsp",
      -- diagnostics_indicator = function(count)
      -- 	return "(" .. count .. ")"
      -- end,
      diagnostics_indicator = function(_, _, diag)
        local icons = {
          Error = "󰅙 ",
          Warn = " ",
          Hint = " ",
          Info = "󰋼 ",
        }
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      separator_style = "thin",
      indicator = {
        icon = "▎",
        style = "icon",
      },
      offsets = {
        {
          filetype = "NvimTree",
          text = function()
            return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          end,
          text_align = "center",
        },
        {
          filetype = "aerial",
          text = "Symbol Outline",
          text_align = "center",
          padding = 0,
        },
      },
    },
    highlights = require("catppuccin.groups.integrations.bufferline").get({
      custom = {
        all = {
          buffer_selected = {
            fg = mocha.peach,
            bg = transparent_background and "NONE" or mocha.base,
            style = { "bold", "italic" },
          },
        },
      },
    }),
  }

  require("bufferline").setup(opts)

  -- Fix bufferline when restoring a session
  vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
    callback = function()
      vim.schedule(function()
        pcall(nvim_bufferline)
      end)
    end,
  })
end
