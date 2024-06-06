local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ============== Delete Default Keymaps ===============

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

-- =====================================================
keymap.set("n", "<A-w>", function()
  require("mini.bufremove").delete(0, false)
end)
keymap.set("n", "<A-s>", "<CMD>w<CR>")
keymap.set("i", "<A-s>", "<ESC><CMD>w<CR>")

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
-- keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Format
keymap.set("n", "<A-S-f>", "<CMD>LazyFormat<CR>")

keymap.set("n", "H", "^")
keymap.set("n", "L", "$")

-- ====================== Plugins Keymaps ============================

-- Naviagte
keymap.set({ "n", "t" }, "<A-h>", "<CMD>NavigatorLeft<CR>")
keymap.set({ "n", "t" }, "<A-l>", "<CMD>NavigatorRight<CR>")
keymap.set({ "n", "t" }, "<A-k>", "<CMD>NavigatorUp<CR>")
keymap.set({ "n", "t" }, "<A-j>", "<CMD>NavigatorDown<CR>")
keymap.set({ "n", "t" }, "<A-p>", "<CMD>NavigatorPrevious<CR>")

-- BufferLine
keymap.set("n", "<C-h>", "<CMD>BufferLineCyclePrev<CR>")
keymap.set("n", "<C-l>", "<CMD>BufferLineCycleNext<CR>")
