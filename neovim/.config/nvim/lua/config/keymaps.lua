local keymap = vim.keymap
local map = vim.keymap.set

--------------- Delete Default Keymaps ---------------

keymap.del("n", "<A-j>")
keymap.del("n", "<A-k>")

keymap.del("n", "<C-h>")
keymap.del("n", "<C-j>")
keymap.del("n", "<C-k>")
keymap.del("n", "<C-l>")

-- Format
keymap.del("n", "<leader>cf")

--Buffer
keymap.del("n", "<S-h>")
keymap.del("n", "<S-l>")
keymap.del("n", "[b")
keymap.del("n", "]b")
keymap.del("n", "<leader>bb")
keymap.del("n", "<leader>`")

-------------------------------------------------------

map("i", "jk", "<ESC>")

map("n", "H", "^")
map("n", "L", "$")

map("n", "<A-w>", "<CMD>BufDel<CR>", { desc = "Close Buffer" })
map("n", "<A-s>", "<CMD>w<CR>")
map("i", "<A-s>", "<ESC><CMD>w<CR>")

-- Resize window using <ctrl> arrow keys
map("n", "<S-Up>", "<CMD>resize +2<CR>", { desc = "Increase Window Height" })
map("n", "<S-Down>", "<CMD>resize -2<CR>", { desc = "Decrease Window Height" })
map("n", "<S-Left>", "<CMD>vertical resize -2<CR>", { desc = "Decrease Window Width" })
map("n", "<S-Right>", "<CMD>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- Format
keymap.set("n", "<A-S-f>", "<CMD>LazyFormat<CR>", { desc = "Format" })

-- Commenting
map("n", "gco", "o<esc>Vcx<esc><CMD>normal gcc<CR>fxa<BS>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><CMD>normal gcc<CR>fxa<BS>", { desc = "Add Comment Above" })

--------------- Naviagte ---------------
map({ "n", "t" }, "<A-h>", "<CMD>NavigatorLeft<CR>")
map({ "n", "t" }, "<A-l>", "<CMD>NavigatorRight<CR>")
map({ "n", "t" }, "<A-k>", "<CMD>NavigatorUp<CR>")
map({ "n", "t" }, "<A-j>", "<CMD>NavigatorDown<CR>")
map({ "n", "t" }, "<A-p>", "<CMD>NavigatorPrevious<CR>")

--------------- BufferLine ---------------
map("n", "<C-h>", "<CMD>BufferLineCyclePrev<CR>")
map("n", "<C-l>", "<CMD>BufferLineCycleNext<CR>")
map("n", "<A-S-h>", "<CMD>BufferLineMovePrev<CR>")
map("n", "<A-S-l>", "<CMD>BufferLineMoveNext<CR>")
map("n", "<leader>1", "<CMD>BufferLineGoToBuffer 1<CR>")
map("n", "<leader>2", "<CMD>BufferLineGoToBuffer 2<CR>")
map("n", "<leader>3", "<CMD>BufferLineGoToBuffer 3<CR>")
map("n", "<leader>4", "<CMD>BufferLineGoToBuffer 4<CR>")
map("n", "<leader>5", "<CMD>BufferLineGoToBuffer 5<CR>")
map("n", "<leader>6", "<CMD>BufferLineGoToBuffer 6<CR>")
map("n", "<leader>7", "<CMD>BufferLineGoToBuffer 7<CR>")
map("n", "<leader>8", "<CMD>BufferLineGoToBuffer 8<CR>")
map("n", "<leader>9", "<CMD>BufferLineGoToBuffer 9<CR>")
