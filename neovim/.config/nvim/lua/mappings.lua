-- require "nvchad.mappings"
local del = vim.keymap.del
local map = vim.keymap.set

-- map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
-- map("i", "<C-e>", "<End>", { desc = "move end of line" })
-- map("i", "<C-h>", "<Left>", { desc = "move left" })
-- map("i", "<C-l>", "<Right>", { desc = "move right" })
-- map("i", "<C-j>", "<Down>", { desc = "move down" })
-- map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "lsp diagnostic loclist" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

-- Comment
map("n", "<A-/>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "comment toggle" })

map(
  "v",
  "<A-/>",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "comment toggle" }
)

-- terminal
-- map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

-- blankline
map("n", "<leader>cc", function()
  local config = { scope = {} }
  config.scope.exclude = { language = {}, node_type = {} }
  config.scope.include = { node_type = {} }
  local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

  if node then
    local start_row, _, end_row, _ = node:range()
    if start_row ~= end_row then
      vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
      vim.api.nvim_feedkeys("_", "n", true)
    end
  end
end, { desc = "blankline jump to current context" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Save file
map({ "i", "x", "n", "s" }, "<A-s>", "<CMD>w<cr><ESC>", { desc = "Save File" })
-- Close Buffer
map("n", "<A-w>", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Close Buffer" })
-- Quit all
map("n", "<leader>qq", "<CMD>qa<CR>", { desc = "Quit All" })
-- Windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
-- Resize window using <ctrl> arrow keys
map("n", "<S-Up>", "<CMD>resize +2<CR>", { desc = "Increase Window Height" })
map("n", "<S-Down>", "<CMD>resize -2<CR>", { desc = "Decrease Window Height" })
map("n", "<S-Left>", "<CMD>vertical resize -2<CR>", { desc = "Decrease Window Width" })
map("n", "<S-Right>", "<CMD>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- Move Lines
map("i", "<A-j>", "<esc><CMD>m .+1<CR>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><CMD>m .-2<CR>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Up" })

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- Delete a word backwards
-- map("n", "dw", 'vb"_d')

-- Format
map("n", "<A-S-f>", function()
  require("conform").format {
    bufnr = vim.api.nvim_get_current_buf(),
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  }
end, { desc = "Code Format" })

map("n", "H", "^", { desc = "move beginning of line" })
map("n", "L", "$", { desc = "move end of line" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")


-- ====================== Plugins Keymaps ============================

-- Naviagte
map({ "n", "t" }, "<A-h>", "<CMD>NavigatorLeft<CR>", { desc = "switch window left" })
map({ "n", "t" }, "<A-l>", "<CMD>NavigatorRight<CR>", { desc = "switch window right" })
map({ "n", "t" }, "<A-k>", "<CMD>NavigatorUp<CR>", { desc = "switch window up" })
map({ "n", "t" }, "<A-j>", "<CMD>NavigatorDown<CR>", { desc = "switch window down" })
map({ "n", "t" }, "<A-p>", "<CMD>NavigatorPrevious<CR>", { desc = "switch window previous" })

-- Nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- Telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "telescope nvchad themes" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)
