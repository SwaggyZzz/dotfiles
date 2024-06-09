local map = vim.keymap.set

map("i", "jk", "<ESC>")

map("n", "H", "^")
map("n", "L", "$")

-- Save file
map({ "i", "x", "n", "s" }, "<A-s>", "<CMD>w<cr><ESC>", { desc = "Save File" })
-- Close Buffer
map("n", "<A-w>", "<CMD>BufDel<CR>", { desc = "Close Buffer" })
-- Quit all
map("n", "<leader>qq", "<CMD>qa<CR>", { desc = "Quit All" })

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- Format
map({ "n", "v" }, "<A-S-f>", function()
	vim.api.nvim_command([[CodeFormat]])
end, { desc = "Format" })

-- Select all
map("n", "<C-a>", "gg<S-v>G")

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

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><CMD>normal gcc<CR>fxa<BS>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><CMD>normal gcc<CR>fxa<BS>", { desc = "Add Comment Above" })

-- map("n", "n", "nzz")
-- map("n", "N", "Nzz")

--------------- NvimTree ---------------
map("n", "<leader>e", "<CMD>NvimTreeToggle<CR>", { desc = "FileTree Toggle" })
map("n", "<leader>ne", "<CMD>NvimTreeFocus<CR>", { desc = "FileTree Focus" })
map("n", "<leader>nf", "<CMD>NvimTreeFindFile<CR>", { desc = "FileTree Find File" })
map("n", "<leader>nr", "<CMD>NvimTreeRefresh<CR>", { desc = "FileTree Refresh" })

--------------- Telescope ---------------
map("n", "<leader>ff", "<CMD>Telescope find_files<CR>", { desc = "Telescope find file" })
map("n", "<leader>fs", function()
	require("telescope.builtin").grep_string({ word_match = "-w" })
end, { desc = "Telescope find current word" })
map("v", "<leader>fs", function()
	require("telescope.builtin").grep_string({ word_match = "-w" })
end, { desc = "Telescope find selection word" })
map("n", "<leader>/", function()
	require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Telescope find word" })

--------------- Naviagte ---------------
map({ "n", "t" }, "<A-h>", "<CMD>NavigatorLeft<CR>")
map({ "n", "t" }, "<A-l>", "<CMD>NavigatorRight<CR>")
map({ "n", "t" }, "<A-k>", "<CMD>NavigatorUp<CR>")
map({ "n", "t" }, "<A-j>", "<CMD>NavigatorDown<CR>")
map({ "n", "t" }, "<A-p>", "<CMD>NavigatorPrevious<CR>")

--------------- BufferLine ---------------
map("n", "<C-h>", "<CMD>BufferLineCyclePrev<CR>")
map("n", "<C-l>", "<CMD>BufferLineCycleNext<CR>")
map("n", "<leader>1", "<CMD>BufferLineGoToBuffer 1<CR>")
map("n", "<leader>2", "<CMD>BufferLineGoToBuffer 2<CR>")
map("n", "<leader>3", "<CMD>BufferLineGoToBuffer 3<CR>")
map("n", "<leader>4", "<CMD>BufferLineGoToBuffer 4<CR>")
map("n", "<leader>5", "<CMD>BufferLineGoToBuffer 5<CR>")
map("n", "<leader>6", "<CMD>BufferLineGoToBuffer 6<CR>")
map("n", "<leader>7", "<CMD>BufferLineGoToBuffer 7<CR>")
map("n", "<leader>8", "<CMD>BufferLineGoToBuffer 8<CR>")
map("n", "<leader>9", "<CMD>BufferLineGoToBuffer 9<CR>")
