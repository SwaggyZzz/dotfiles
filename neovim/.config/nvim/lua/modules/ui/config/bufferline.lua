return function()
  local bufferline = require("bufferline")

  -- can't be set in settings.lua because default tabline would flash before bufferline is loaded
  vim.opt.showtabline = 2


  local function is_ft(b, ft)
    return vim.bo[b].filetype == ft
  end

  local function diagnostics_indicator(num, _, diagnostics, _)
    local icons = require('swaggyz.new-icons')
    local result = {}
    local symbols = {
      error = icons.diagnostics.Error,
      warning = icons.diagnostics.Warning,
      info = icons.diagnostics.Information,
    }
    -- if not use_icons then
    --   return "(" .. num .. ")"
    -- end
    for name, count in pairs(diagnostics) do
      if symbols[name] and count > 0 then
        table.insert(result, symbols[name] .. " " .. count)
      end
    end
    result = table.concat(result, " ")
    return #result > 0 and result or ""
  end

  local function custom_filter(buf, buf_nums)
    local logs = vim.tbl_filter(function(b)
      return is_ft(b, "log")
    end, buf_nums or {})
    if vim.tbl_isempty(logs) then
      return true
    end
    local tab_num = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr "$"
    local is_log = is_ft(buf, "log")
    if last_tab == 1 then
      return true
    end
    -- only show log buffers in secondary tabs
    return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
  end

  bufferline.setup({
    options = {
      close_command = function(n)
        require("mini.bufremove").delete(n, false)
      end,
      right_mouse_command = function(n)
        require("mini.bufremove").delete(n, false)
      end,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = diagnostics_indicator,
      show_buffer_close_icons = false,
      show_tab_indicators = true,
      always_show_bufferline = true,
      max_name_length = 20,
      max_prefix_length = 13,
      tab_size = 20,
      -- indicator = {
      --   icon = "▎", -- this should be omitted if indicator style is not 'icon'
      --   style = "icon", -- can also be 'underline'|'none',
      -- },
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      separator_style = "thin",
      numbers = function(opts)
        return string.format("%s", opts.ordinal)
      end,
      custom_filter = custom_filter,
      offsets = {
        -- {
        --   filetype = "NvimTree",
        --   text = "File Explorer",
        --   text_align = "center",
        --   highlight = "Directory",
        -- },
        {
          filetype = "NvimTree",
          text = "Explorer",
          highlight = "PanelHeading",
          padding = 1,
        },
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
        {
          filetype = "lspsagaoutline",
          text = "Lspsaga Outline",
          text_align = "center",
        },
      },
    },
    highlights = {
      background = {
        italic = true,
      },
      buffer_selected = {
        bold = true,
      },
    },
  })
end
