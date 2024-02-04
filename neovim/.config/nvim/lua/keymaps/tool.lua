local map = require('swaggyz.keymap')
local cmd = map.cmd

-- Telescope
map.n({
  ['<Leader>fw'] = cmd('Telescope live_grep'),
  ['<Leader>fb'] = cmd('Telescope buffers'),
  ['<Leader>ft'] = cmd('Telescope colorscheme'),
  ['<Leader>ff'] = cmd('Telescope find_files find_command=rg,--ignore,--hidden,--files'),
  ['<Leader>fg'] = cmd('Telescope git_files'),
  ['<Leader>fs'] = cmd('Telescope grep_string'),
  ['<Leader>fh'] = cmd('Telescope help_tags'),
  ['<Leader>fo'] = cmd('Telescope oldfiles'),
  ['<Leader>fc'] = cmd('Telescope git_commits'),
})
-- nvim-tree
map.n({
  -- ['<C-n>'] = cmd('Neotree'),
  ['<C-n>'] = cmd('NvimTreeToggle'),
  ['<Leader>nf'] = cmd('NvimTreeFindFile'),
  ['<Leader>nr'] = cmd('NvimTreeRefresh')
})
