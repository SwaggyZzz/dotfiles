return function()
  local opts = {
    options = {
      numbers = "ordinal",
      close_command = "BufDel! %d",
      right_mouse_command = "BufDel! %d",
      color_icons = true,
      always_show_bufferline = true,
      diagnostics = "nvim_lsp",
      show_buffer_close_icons = false,
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
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "center",
          padding = 0,
        },
        {
          filetype = "aerial",
          text = "Symbol Outline",
          text_align = "center",
          padding = 0,
        },
      },
    },
  }

  opts.highlights = require("catppuccin.groups.integrations.bufferline").get()

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
