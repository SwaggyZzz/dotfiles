return function()
  -- local icons = { ui = require("swaggyz.icons").get("ui") }

  -- local opts = {
  --   options = {
  --     number = nil,
  --     numbers = "ordinal",
  --     modified_icon = icons.ui.Modified,
  --     buffer_close_icon = icons.ui.Close,
  --     left_trunc_marker = icons.ui.Left,
  --     right_trunc_marker = icons.ui.Right,
  --     max_name_length = 14,
  --     max_prefix_length = 13,
  --     tab_size = 20,
  --     color_icons = true,
  --     show_buffer_icons = true,
  --     show_buffer_close_icons = true,
  --     show_close_icon = true,
  --     show_tab_indicators = true,
  --     enforce_regular_tabs = true,
  --     persist_buffer_sort = true,
  --     always_show_bufferline = true,
  --     separator_style = "thin",
  --     diagnostics = "nvim_lsp",
  --     diagnostics_indicator = function(count)
  --       return "(" .. count .. ")"
  --     end,
  --     offsets = {
  --       {
  --         filetype = "NvimTree",
  --         text = "File Explorer",
  --         text_align = "center",
  --         padding = 1,
  --       },
  --       {
  --         filetype = "lspsagaoutline",
  --         text = "Lspsaga Outline",
  --         text_align = "center",
  --         padding = 1,
  --       },
  --     },
  --   },
  --   -- Change bufferline's highlights here! See `:h bufferline-highlights` for detailed explanation.
  --   -- Note: If you use catppuccin then modify the colors below!
  --   highlights = {},
  -- }

  -- require("bufferline").setup(opts)

  local bufferline = require("bufferline")

  bufferline.setup({
    options = {
      close_command = function(n)
        require("mini.bufremove").delete(n, false)
      end,
      right_mouse_command = function(n)
        require("mini.bufremove").delete(n, false)
      end,
      show_buffer_close_icons = false,
      separator_style = { "|", "|" },
      always_show_bufferline = true,
      style_preset = bufferline.style_preset.no_italic,
      numbers = function(opts)
        return string.format("%s", opts.ordinal)
      end,
      custom_filter = function(buf_number)
        -- filter out filetypes you don't want to see
        if vim.bo[buf_number].filetype ~= "qf" then
          return true
        end
      end,
      -- offsets = {
      --   {
      --     filetype = "NvimTree",
      --     text = "File Explorer",
      --     -- highlight = "EcovimNvimTreeTitle",
      --     text_align = "center",
      --     separator = true,
      --   },
      -- },
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "center",
          padding = 1,
        },
        {
          filetype = "lspsagaoutline",
          text = "Lspsaga Outline",
          text_align = "center",
          padding = 1,
        },
      },
    },
  })
end
