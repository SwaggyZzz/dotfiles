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

-- ["K"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover" },
-- ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto definition" },
-- ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto Declaration" },
-- ["gr"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "Goto references" },
-- ["gI"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Goto Implementation" },
-- ["gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "show signature help" },
-- ["gl"] = {
--   function()
--     local float = vim.diagnostic.config().float

--     if float then
--       local config = type(float) == "table" and float or {}
--       config.scope = "line"

--       vim.diagnostic.open_float(config)
--     end
--   end,
--   "Show line diagnostics",
-- }
