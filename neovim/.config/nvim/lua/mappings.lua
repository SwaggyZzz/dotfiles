-- require "nvchad.mappings"

local map = vim.keymap.set
local del = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

-- move buffer left
map("n", "<leader>bl", function()
  require("nvchad.tabufline").move_buf(-1)
end)
-- move buffer right
map("n", "<leader>br", function()
  require("nvchad.tabufline").move_buf(1)
end)

for i = 1, 9, 1 do
  map("n", string.format("<leader>%s", i), function()
    vim.api.nvim_set_current_buf(vim.t.bufs[i])
  end)
end

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

map("n", "H", "^", { desc = "move beginning of line" })
map("n", "L", "$", { desc = "move end of line" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Format
map({ "n", "v" }, "<A-S-f>", function()
  require("conform").format {
    bufnr = vim.api.nvim_get_current_buf(),
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
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
end, { desc = "Format" })

--------------- Telescope ---------------
map("n", "<leader>ff", "<CMD>Telescope find_files<CR>", { desc = "Telescope find file" })
map("n", "<leader>/", "<cmd>Telescope live_grep<CR>", { desc = "Telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope find buffers" })
map("n", "<leader>fs", function()
  require("telescope.builtin").grep_string { word_match = "-w" }
end, { desc = "Telescope find current word" })
map("v", "<leader>fs", function()
  require("telescope.builtin").grep_string { word_match = "-w" }
end, { desc = "Telescope find selection word" })
-- map("n", "<leader>/", function()
--   require("telescope").extensions.live_grep_args.live_grep_args()
-- end, { desc = "Telescope find word" })

--------------- NvimTree ---------------
map("n", "<leader>e", "<CMD>NvimTreeToggle<CR>", { desc = "FileTree Toggle" })
map("n", "<leader>E", "<CMD>NvimTreeFocus<CR>", { desc = "FileTree Focus" })
-- map("n", "<leader>er", "<CMD>NvimTreeRefresh<CR>", { desc = "FileTree Refresh" })

--------------- Naviagte -----------------
map({ "n", "t" }, "<A-h>", "<CMD>NavigatorLeft<CR>")
map({ "n", "t" }, "<A-l>", "<CMD>NavigatorRight<CR>")
map({ "n", "t" }, "<A-k>", "<CMD>NavigatorUp<CR>")
map({ "n", "t" }, "<A-j>", "<CMD>NavigatorDown<CR>")
map({ "n", "t" }, "<A-p>", "<CMD>NavigatorPrevious<CR>")
