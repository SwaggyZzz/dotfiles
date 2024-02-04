local map = require('swaggyz.keymap')
local cmd = map.cmd

-- Bufferline
map.n({
  ['<C-h>'] = cmd('BufferLineCyclePrev'),
  ['<C-l>'] = cmd('BufferLineCycleNext'),
  ['<A-S-h>'] = cmd('BufferLineMovePrev'),
  ['<A-S-l>'] = cmd('BufferLineMoveNext'),
  ['<Leader>1'] = cmd('BufferLineGoToBuffer 1'),
  ['<Leader>2'] = cmd('BufferLineGoToBuffer 2'),
  ['<Leader>3'] = cmd('BufferLineGoToBuffer 3'),
  ['<Leader>4'] = cmd('BufferLineGoToBuffer 4'),
  ['<Leader>5'] = cmd('BufferLineGoToBuffer 5'),
  ['<Leader>6'] = cmd('BufferLineGoToBuffer 6'),
  ['<Leader>7'] = cmd('BufferLineGoToBuffer 7'),
  ['<Leader>8'] = cmd('BufferLineGoToBuffer 8'),
  ['<Leader>9'] = cmd('BufferLineGoToBuffer 9'),
  ['<A-1>'] = cmd('BufferLineGoToBuffer 1'),
  ['<A-2>'] = cmd('BufferLineGoToBuffer 2'),
  ['<A-3>'] = cmd('BufferLineGoToBuffer 3'),
  ['<A-4>'] = cmd('BufferLineGoToBuffer 4'),
  ['<A-5>'] = cmd('BufferLineGoToBuffer 5'),
  ['<A-6>'] = cmd('BufferLineGoToBuffer 6'),
  ['<A-7>'] = cmd('BufferLineGoToBuffer 7'),
  ['<A-8>'] = cmd('BufferLineGoToBuffer 8'),
  ['<A-9>'] = cmd('BufferLineGoToBuffer 9'),
})
