local map = vim.keymap.set

map('i', 'jk', '<ESC>')

map({ 'n', 'x', 'o' }, '<S-H>', '^', { desc = 'Start of line' })
map({ 'n', 'x', 'o' }, '<S-L>', '$', { desc = 'End of line' })

map('i', '<C-h>', '<Left>')
map('i', '<C-l>', '<Right>')
map('i', '<C-j>', '<Down>')
map('i', '<C-k>', '<Up>')

-- Save file
map({ 'i', 'x', 'n', 's' }, '<A-s>', '<CMD>w<cr><ESC>', { desc = 'Save File' })
-- Close Buffer
map('n', '<A-w>', function()
  if #vim.fn.getbufinfo { buflisted = 1 } < 2 then
    -- exit when there is only one buffer left
    vim.cmd 'qall!'
    return
  end
  Snacks.bufdelete()
end, { desc = 'Close Buffer' })
-- Quit all
map('n', '<leader>qq', '<CMD>qa<CR>', { desc = 'Quit All' })

-- Increment/decrement
-- map("n", "+", "<C-a>")
-- map("n", "-", "<C-x>")

-- Format
map({ 'n', 'v', 'i' }, '<A-S-f>', function()
  require('conform').format {
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  }
  -- local formatters = require("conform").list_formatters()
  -- local str = ""
  --
  -- vim.notify(tostring(#formatters))
  --
  -- for _, value in ipairs(formatters) do
  --   str = str .. ", " .. value.name
  -- end
  -- vim.notify(str)
end, { desc = 'Format' })

-- Windows
map('n', '<leader>ww', '<C-W>p', { desc = 'Other Window', remap = true })
map('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', remap = true })
map('n', '<leader>w-', '<C-W>s', { desc = 'Split Window Below', remap = true })
map('n', '<leader>w|', '<C-W>v', { desc = 'Split Window Right', remap = true })
map('n', '<leader>we', '<C-W>=', { desc = 'Make Split Window Size Equal', remap = true })
map('n', '<leader>wx', '<CMD>close<CR>', { desc = 'Close Current Split', remap = true })
map('n', '<leader>wo', '<C-W>o', { desc = 'Close Other Split', remap = true })
map('n', '<leader>-', '<C-W>s', { desc = 'Split Window Below', remap = true })
map('n', '<leader>|', '<C-W>v', { desc = 'Split Window Right', remap = true })
-- Resize window using <ctrl> arrow keys
map('n', '<leader>wk', '<CMD>resize +2<CR>', { desc = 'Increase Window Height' })
map('n', '<leader>wj', '<CMD>resize -2<CR>', { desc = 'Decrease Window Height' })
map('n', '<leader>wh', '<CMD>vertical resize -2<CR>', { desc = 'Decrease Window Width' })
map('n', '<leader>wl', '<CMD>vertical resize +2<CR>', { desc = 'Increase Window Width' })

-- Move Lines
map('i', '<A-j>', '<esc><CMD>m .+1<CR>==gi', { desc = 'Move Down' })
map('i', '<A-k>', '<esc><CMD>m .-2<CR>==gi', { desc = 'Move Up' })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move Down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move Up' })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- commenting
map('n', 'gco', 'o<esc>Vcx<esc><CMD>normal gcc<CR>fxa<BS>', { desc = 'Add Comment Below' })
map('n', 'gcO', 'O<esc>Vcx<esc><CMD>normal gcc<CR>fxa<BS>', { desc = 'Add Comment Above' })

--------------- Naviagte -----------------
map({ 'n', 't' }, '<A-h>', '<CMD>NavigatorLeft<CR>')
map({ 'n', 't' }, '<A-l>', '<CMD>NavigatorRight<CR>')
map({ 'n', 't' }, '<A-k>', '<CMD>NavigatorUp<CR>')
map({ 'n', 't' }, '<A-j>', '<CMD>NavigatorDown<CR>')
map({ 'n', 't' }, '<A-p>', '<CMD>NavigatorPrevious<CR>')

--------------- BufferLine ---------------
map('n', '<C-h>', '<CMD>BufferLineCyclePrev<CR>')
map('n', '<C-l>', '<CMD>BufferLineCycleNext<CR>')
map('n', '<A->>', '<CMD>BufferLineMoveNext<CR>')
map('n', '<A-<>', '<CMD>BufferLineMovePrev<CR>')
map('n', '<leader>1', '<CMD>BufferLineGoToBuffer 1<CR>')
map('n', '<leader>2', '<CMD>BufferLineGoToBuffer 2<CR>')
map('n', '<leader>3', '<CMD>BufferLineGoToBuffer 3<CR>')
map('n', '<leader>4', '<CMD>BufferLineGoToBuffer 4<CR>')
map('n', '<leader>5', '<CMD>BufferLineGoToBuffer 5<CR>')
map('n', '<leader>6', '<CMD>BufferLineGoToBuffer 6<CR>')
map('n', '<leader>7', '<CMD>BufferLineGoToBuffer 7<CR>')
map('n', '<leader>8', '<CMD>BufferLineGoToBuffer 8<CR>')
map('n', '<leader>9', '<CMD>BufferLineGoToBuffer 9<CR>')
