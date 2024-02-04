local map = require('swaggyz.keymap')
local cmd = map.cmd

-- Comment
map.n({
  ['<A-/>'] = 'gcc',
})
map.v({
  ['<A-/>'] = 'gcc<ESC>',
})
