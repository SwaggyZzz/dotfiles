local conditions = require 'configs.ui.lualine.conditions'

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local function stbufnr()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

local branch = ''

return {
  mode = {
    function()
      return ' ' .. '󰀘' .. ' '
    end,
    padding = { left = 0, right = 0 },
    color = {},
    cond = nil,
  },
  branch = {
    'b:gitsigns_head',
    icon = branch,
    color = { gui = 'bold' },
  },
  filename = {
    function()
      local icon = '󰈚'
      local path = vim.api.nvim_buf_get_name(stbufnr())
      local name = (path == '' and 'Empty ') or path:match '([^/\\]+)[/\\]*$'

      if name ~= 'Empty ' then
        local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

        if devicons_present then
          local ft_icon = devicons.get_icon(name)
          icon = (ft_icon ~= nil and ft_icon) or icon
        end
      end

      return icon .. ' ' .. name
    end,
    color = {},
    cond = nil,
  },
  diff = {
    'diff',
    source = diff_source,
    symbols = {
      added = '' .. ' ',
      modified = '' .. ' ',
      removed = '' .. ' ',
    },
    padding = { left = 1, right = 1 },
    cond = nil,
  },
  diagnostics = {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = {
      error = '' .. ' ',
      warn = '' .. ' ',
      info = '' .. ' ',
      hint = '' .. ' ',
    },
    -- cond = conditions.hide_in_width,
  },
  treesitter = {
    function()
      return ''
    end,
    color = function()
      local buf = vim.api.nvim_get_current_buf()
      local ts = vim.treesitter.highlighter.active[buf]
      return { fg = ts and not vim.tbl_isempty(ts) and '#98be65' or '#ec5f67' }
    end,
    cond = conditions.hide_in_width,
  },
  lsp = {
    function()
      local buf_clients = vim.lsp.get_clients { bufnr = 0 }
      if #buf_clients == 0 then
        return 'LSP Inactive'
      end

      local buf_ft = vim.bo.filetype
      local buf_client_names = {}
      local copilot_active = false

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name == 'vtsls' then
          buf_client_names = { 'vtsls' }
          break
        end
        if client.name ~= 'null-ls' and client.name ~= 'copilot' then
          table.insert(buf_client_names, client.name)
        end

        if client.name == 'copilot' then
          copilot_active = true
        end
      end

      local unique_client_names = table.concat(buf_client_names, ', ')
      local language_servers = string.format('[%s]', unique_client_names)

      if copilot_active then
        language_servers = language_servers .. '%#SLCopilot#' .. ' ' .. '' .. '%*'
      end

      return language_servers
    end,
    color = { gui = 'bold' },
    cond = conditions.hide_in_width,
  },
  location = { 'location' },
  progress = {
    'progress',
    fmt = function()
      return '%P/%L'
    end,
    color = {},
  },
  -- progress = {
  --   function()
  --     local bar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
  --     local curr_line = vim.api.nvim_win_get_cursor(0)[1]
  --     local lines = vim.api.nvim_buf_line_count(0)
  --     local i = math.floor((curr_line - 1) / lines * #bar) + 1
  --     return string.rep(bar[i], 2)
  --   end,
  -- },
  spaces = {
    function()
      local shiftwidth = vim.api.nvim_get_option_value('shiftwidth', { buf = 0 })
      return '󰌒' .. ' ' .. shiftwidth
    end,
    padding = 1,
  },
  formatter = {
    function()
      local buf = vim.api.nvim_get_current_buf()
      local formatters = require('conform').list_formatters_to_run(buf)

      return table.concat(formatters, ', ')
    end,
    padding = { left = 1, right = 1 },
    cond = conditions.hide_in_width,
  },
}
