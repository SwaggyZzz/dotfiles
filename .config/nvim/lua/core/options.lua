local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.shiftround = true -- Round indent 缩进自动四舍五入为倍数
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

opt.jumpoptions = 'view'

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true -- Enable highlighting of the current line

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = 'dark' -- colorschemes that can be light or dark will be made dark
opt.signcolumn = 'yes' -- 固定宽度4列，避免符号重叠

opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

opt.timeout = true
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }

opt.showmode = false

opt.undofile = true
opt.undolevels = 10000

opt.updatetime = 260

opt.scrolloff = 5 -- Lines of context

opt.completeopt = 'menu,menuone,noselect'

opt.confirm = true -- Confirm to save changes before exiting modified buffer

opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}
opt.foldenable = true
opt.foldcolumn = '0'
opt.foldlevel = 99
opt.foldlevelstart = 99

opt.shortmess:append { W = true, I = true, c = true, C = true }

opt.spelllang = { 'en' }

opt.pumheight = 10 -- Maximum number of entries in a popup

opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode

-- Big file limit
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- opt.autowrite = true -- Enable auto write
-- -- only set clipboard if not in ssh, to make sure the OSC 52
-- -- integration works automatically. Requires Neovim >= 0.10.0
-- opt.clipboard = "unnamedplus" -- Sync with system clipboard
-- opt.completeopt = "menu,menuone,noselect"
-- opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
-- opt.confirm = true -- Confirm to save changes before exiting modified buffer
-- opt.cursorline = true -- Enable highlighting of the current line
-- opt.expandtab = true -- Use spaces instead of tabs
-- opt.fillchars = {
--   foldopen = "",
--   foldclose = "",
--   fold = " ",
--   foldsep = " ",
--   diff = "╱",
--   eob = " ",
-- }
-- opt.foldenable = true
-- opt.foldcolumn = "0"
-- opt.foldlevel = 99
-- opt.foldlevelstart = 99
-- -- opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
-- opt.formatoptions = "jcroqlnt" -- tcqj
-- opt.grepformat = "%f:%l:%c:%m"
-- opt.ignorecase = true -- Ignore case
-- opt.inccommand = "nosplit" -- preview incremental substitute
-- opt.laststatus = 3 -- global statusline
-- opt.list = true -- Show some invisible characters (tabs...
-- opt.mouse = "a" -- Enable mouse mode
-- opt.number = true -- Print line number
-- opt.pumblend = 10 -- Popup blend
-- opt.pumheight = 10 -- Maximum number of entries in a popup
-- opt.relativenumber = true -- Relative line numbers
-- opt.scrolloff = 4 -- Lines of context
-- opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
-- opt.shiftround = true -- Round indent
-- opt.shiftwidth = 2 -- Size of an indent
-- opt.shortmess:append({ W = true, I = true, c = true, C = true })
-- opt.showmode = false -- Dont show mode since we have a statusline
-- opt.sidescrolloff = 8 -- Columns of context
-- opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
-- opt.smartcase = true -- Don't ignore case with capitals
-- opt.smartindent = true -- Insert indents automatically
-- opt.spelllang = { "en" }
-- opt.splitbelow = true -- Put new windows below current
-- opt.splitkeep = "screen"
-- opt.splitright = true -- Put new windows right of current
-- opt.tabstop = 2 -- Number of spaces tabs count for
-- opt.termguicolors = true -- True color support
-- opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
-- opt.undofile = true
-- opt.undolevels = 10000
-- opt.updatetime = 200
-- opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
-- opt.wildmode = "longest:full,full" -- Command-line completion mode
-- opt.winminwidth = 5 -- Minimum window width
-- opt.wrap = false -- Disable line wrap

-- if vim.fn.has("nvim-0.10") == 1 then
--   opt.smoothscroll = true
--   opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
--   opt.foldmethod = "expr"
--   opt.foldtext = ""
-- else
--   opt.foldmethod = "indent"
--   opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
-- end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
