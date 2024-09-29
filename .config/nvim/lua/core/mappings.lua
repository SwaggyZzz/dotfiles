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
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
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

-- Windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>we", "<C-W>=", { desc = "Make Split Window Size Equal", remap = true })
map("n", "<leader>wx", "<CMD>close<CR>", { desc = "Close Current Split", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
-- Resize window using <ctrl> arrow keys
map("n", "<A-S-k>", "<CMD>resize +2<CR>", { desc = "Increase Window Height" })
map("n", "<A-S-j>", "<CMD>resize -2<CR>", { desc = "Decrease Window Height" })
map("n", "<A-S-h>", "<CMD>vertical resize -2<CR>", { desc = "Decrease Window Width" })
map("n", "<A-S-l>", "<CMD>vertical resize +2<CR>", { desc = "Increase Window Width" })

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

--------------- Lsp --------------------

--------------- NvimTree ---------------
-- map("n", "<leader>ee", "<CMD>NvimTreeToggle<CR>", { desc = "FileTree Toggle" })
-- map("n", "<leader>ef", "<CMD>NvimTreeFindFileToggle<CR>", { desc = "FileTree Find File Toggle" })
-- map("n", "<leader>er", "<CMD>NvimTreeRefresh<CR>", { desc = "FileTree Refresh" })

--------------- NeoTree ---------------
map("n", "<leader>ee", "<CMD>Neotree toggle<CR>", { desc = "FileTree Toggle" })

--------------- Telescope ---------------
map("n", "<leader>ff", "<CMD>Telescope find_files<CR>", { desc = "Telescope Find File" })
map("n", "<leader>fF", function()
  require("utils.telescope").find_files_by_path()
end, { desc = "Telescope Find File By Path" })
map("n", "<leader>fw", "<CMD>Telescope live_grep_args<CR>", { desc = "Telescope Find Word" })
map("n", "<leader>fb", "<CMD>Telescope buffers<CR>", { desc = "Telescope Find Buffers" })
map("n", "<leader>fs", function()
  require("telescope.builtin").grep_string({ word_match = "-w" })
end, { desc = "Telescope Find Current Word" })
map("v", "<leader>fs", function()
  require("telescope.builtin").grep_string({ word_match = "-w" })
end, { desc = "Telescope Sind Selection Word" })
map("n", "<leader>ft", "<CMD>TodoTelescope<CR>", { desc = "Telescope Find Todos" })
map("n", "<leader>/", function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    previewer = false,
  }))
end, { desc = "Telescope Find Buffer Word" })
-- map("n", "<leader>/", "<CMD>Telescope live_grep<CR>", { desc = "Telescope find word" })
-- map("n", "<leader>/", function()
--   require("telescope").extensions.live_grep_args.live_grep_args()
-- end, { desc = "Telescope find word" })

--------------- Naviagte -----------------
map({ "n", "t" }, "<A-h>", "<CMD>NavigatorLeft<CR>")
map({ "n", "t" }, "<A-l>", "<CMD>NavigatorRight<CR>")
map({ "n", "t" }, "<A-k>", "<CMD>NavigatorUp<CR>")
map({ "n", "t" }, "<A-j>", "<CMD>NavigatorDown<CR>")
map({ "n", "t" }, "<A-p>", "<CMD>NavigatorPrevious<CR>")

--------------- BufferLine ---------------
map("n", "<C-h>", "<CMD>BufferLineCyclePrev<CR>")
map("n", "<C-l>", "<CMD>BufferLineCycleNext<CR>")
map("n", "<leader>bl", "<CMD>BufferLineMoveNext<CR>")
map("n", "<leader>bh", "<CMD>BufferLineMovePrev<CR>")
map("n", "<leader>1", "<CMD>BufferLineGoToBuffer 1<CR>")
map("n", "<leader>2", "<CMD>BufferLineGoToBuffer 2<CR>")
map("n", "<leader>3", "<CMD>BufferLineGoToBuffer 3<CR>")
map("n", "<leader>4", "<CMD>BufferLineGoToBuffer 4<CR>")
map("n", "<leader>5", "<CMD>BufferLineGoToBuffer 5<CR>")
map("n", "<leader>6", "<CMD>BufferLineGoToBuffer 6<CR>")
map("n", "<leader>7", "<CMD>BufferLineGoToBuffer 7<CR>")
map("n", "<leader>8", "<CMD>BufferLineGoToBuffer 8<CR>")
map("n", "<leader>9", "<CMD>BufferLineGoToBuffer 9<CR>")

--------------- Todo-Comments ------------
map("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next Todo Comment" })
map("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Prev Todo Comment" })
