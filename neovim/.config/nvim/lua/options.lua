require "nvchad.options"

local opt = vim.opt

opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers

vim.o.cursorlineopt ='number,line'
