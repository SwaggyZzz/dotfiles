local map = vim.keymap.set
local format = require("utils.format").format

map("i", "jk", "<ESC>")

map({ "n", "v" }, "<A-S-f>", function()
  format({ force = true })
end, { desc = "Format" })
