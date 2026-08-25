local M = {}

local marker = 'NVIM_NAV:'
local inactive_state = marker .. 'h0j0k0l0'

local last_state
local update_pending = false

local function navigation_mode()
  local mode = vim.api.nvim_get_mode().mode
  return mode == 'n' or mode == 't'
end

local function can_move(direction, current_window)
  return vim.fn.winnr(direction) ~= current_window and '1' or '0'
end

local function current_state()
  -- Alt-based mappings in other modes belong to Neovim, so tmux must not
  -- consume them even when the current split is at an edge.
  if not navigation_mode() then
    return marker .. 'h1j1k1l1'
  end

  local current_window = vim.fn.winnr()
  return marker
    .. 'h'
    .. can_move('h', current_window)
    .. 'j'
    .. can_move('j', current_window)
    .. 'k'
    .. can_move('k', current_window)
    .. 'l'
    .. can_move('l', current_window)
end

local function set_title(state)
  if state == last_state then
    return
  end

  last_state = state
  vim.o.title = true
  vim.o.titlestring = state
end

local function publish()
  update_pending = false
  set_title(current_state())
end

local function schedule_publish()
  if update_pending then
    return
  end

  update_pending = true
  vim.schedule(publish)
end

function M.setup()
  if not require('core.utils').is_ssh() then
    return
  end

  local group = vim.api.nvim_create_augroup('RemoteNavigatorState', { clear = true })

  vim.api.nvim_create_autocmd({
    'VimEnter',
    'WinEnter',
    'WinNew',
    'WinClosed',
    'TabEnter',
    'WinResized',
    'VimResized',
    'ModeChanged',
  }, {
    group = group,
    desc = 'Publish Neovim split boundaries to the local tmux client',
    callback = schedule_publish,
  })

  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = group,
    desc = 'Clear the remote Neovim navigation state',
    callback = function()
      set_title(inactive_state)
      pcall(vim.cmd, 'redraw')
    end,
  })

  schedule_publish()
end

return M
