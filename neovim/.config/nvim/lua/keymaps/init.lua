local map = require('swaggyz.keymap')
local cmd = map.cmd

require("keymaps.completion")
require("keymaps.editor")
require("keymaps.tool")
require("keymaps.ui")


map.a({
  ['dd'] = '"_dd' -- don't yank text on delete ( dd )
})

map.n({
  -- ['j'] = 'gjzz',
  -- ['k'] = 'gkzz',
  ['n'] = 'nzz',
  ['N'] = 'Nzz',
  ['j'] = 'gj',
  ['k'] = 'gk',
  ['H'] = '^',
  ['L'] = '$',
  ["<C-y>"] = cmd('%y+ '),                                               -- Copy whole file content
  ['Y'] = "yg$",                                                         -- yank from current cursor to end of line
  ['<A-s>'] = cmd('w'),
  ['<A-w>'] = function() require("mini.bufremove").delete(0, false) end, -- false --> true (force delete buffer)
  -- ['<A-w>'] = cmd('bd'),
  -- ['<A-w>'] = cmd('bp | bd #'), -- 关闭buf,但不关闭分屏
  ['<A-q>'] = cmd('q'),
  --window
  ['sv'] = cmd('vsp'), -- 分屏
  ['sh'] = cmd('sp'),
  ['sc'] = '<C-w>c',   -- 关闭当前
  ['so'] = '<C-w>o',   -- 关闭其他
  ['s='] = '<C-w>=',   -- 相等比例
  ['<A-h>'] = '<C-w>h',
  ['<A-l>'] = '<C-w>l',
  ['<A-j>'] = '<C-w>j',
  ['<A-k>'] = '<C-w>k',
  ['<S-Up>'] = cmd('resize -2'),
  ['<S-Down>'] = cmd('resize +2'),
  ['<S-Left>'] = cmd('vertical resize -2'),
  ['<S-Right>'] = cmd('vertical resize +2'),
  -- Lazy
  ['<Leader>pu'] = cmd('Lazy update'),
  ['<Leader>pi'] = cmd('Lazy install'),
})

map.i({
  ['<C-d>'] = '<C-o>diw',
  ['<A-h>'] = '<Left>',
  ['<A-l>'] = '<Right>',
  ['<C-a>'] = '<Esc>^i',
  ['<C-e>'] = '<Esc>$a',
  -- ['<C-k>'] = '<C-o>d$',
  ['<A-s>'] = '<ESC>:w<CR>',
  ['<A-j>'] = '<Down>',
  ['<A-k>'] = '<Up>',
  -- ['<C-j>'] = '<C-o>o',
  --@see https://github.com/neovim/neovim/issues/16416
  ['<C-C>'] = '<C-C>',
  --@see https://vim.fandom.com/wiki/Moving_lines_up_or_down
  -- ['<A-j>'] = '<Esc>:m .+1<CR>==gi',
  -- ['<A-k>'] = '<Esc>:m .-2<CR>==gi',
})

map.v({
  ['<A-j>'] = ":m .+1<CR>==",
  ['<A-k>'] = ":m .-2<CR>==",
  ["<"]     = "<gv",
  [">"]     = ">gv"
})
map.x({
  ['<A-j>'] = ":move '>+1<CR>gv-gv",
  ['<A-k>'] = ":move '<-2<CR>gv-gv",
})

-- map.c({
--   ['<C-b>'] = '<Left>',
--   ['<C-f>'] = '<Right>',
--   ['<C-a>'] = '<Home>',
--   ['<C-e>'] = '<End>',
--   ['<C-d>'] = '<Del>',
--   ['<C-h>'] = '<BS>',
-- })

map.t('<Esc>', [[<C-\><C-n>]])
