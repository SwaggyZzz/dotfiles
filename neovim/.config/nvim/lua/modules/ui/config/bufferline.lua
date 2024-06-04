return function()
  local icons = {
    ui = require("utils.icons").get("ui"),
    diagnostics = require("utils.icons").get("diagnostics", true),
  }

  local opts = {
    options = {
      close_command = "BufDel! %d",
      right_mouse_command = "BufDel! %d",
      modified_icon = icons.ui.Modified,
      buffer_close_icon = icons.ui.Close,
      left_trunc_marker = icons.ui.Left,
      right_trunc_marker = icons.ui.Right,
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      diagnostics_indicator = function(_, _, diag)
        local ret = (diag.error and icons.diagnostics.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.diagnostics.Warning .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
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
