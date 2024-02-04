local map = require('swaggyz.keymap')
local cmd = map.cmd

-- LSP
map.n({
  ['<leader>li'] = cmd('LspInfo'),
  ['<leader>ll'] = cmd('LspLog'),
  ['<leader>lr'] = cmd('LspRestart'),
  -- Lspsaga
  ['gp'] = cmd('Lspsaga show_line_diagnostics'),
  ['g]'] = cmd('Lspsaga diagnostic_jump_next'),
  ['g['] = cmd('Lspsaga diagnostic_jump_prev'),
  ['K'] = cmd('Lspsaga hover_doc'),
  ['ga'] = cmd('Lspsaga code_action'),
  ['gD'] = cmd('Lspsaga peek_definition'),
  ['gd'] = cmd('Lspsaga goto_definition'),
  ['gr'] = cmd('Lspsaga rename'),
  ['gR'] = cmd('Lspsaga rename ++project'),
  ['gh'] = cmd('Lspsaga finder'),
  ['go'] = cmd('Lspsaga outline'),
  -- ['<Leader>dw'] = cmd('Lspsaga show_workspace_diagnostics'),
  ['<leader>ad'] = cmd('Lspsaga show_buf_diagnostics'),
  ['<A-S-f>'] = cmd('CodeFormat')
})
