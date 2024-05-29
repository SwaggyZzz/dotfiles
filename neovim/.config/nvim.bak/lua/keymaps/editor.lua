local map = require('swaggyz.keymap')
local cmd = map.cmd

-- Comment
map.n({
  ['<A-/>'] = 'gcc',
})
map.v({
  ['<A-/>'] = 'gcc<ESC>',
})

-- nvim-spectre
map.n({
  ['<leader>S'] = cmd('lua require("spectre").toggle()'),
  ['<leader>sw'] = cmd('lua require("spectre").open_visual({select_word=true})'),
  ['<leader>sf'] = cmd('lua require("spectre").open_file_search({select_word=true})')
})
map.v({
  ['<leader>sw'] = '<esc><cmd>lua require("spectre").open_visual()<CR>'
})
