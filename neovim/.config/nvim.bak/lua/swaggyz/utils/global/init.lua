local M = {}

setmetatable(M, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("swaggyz.utils.global" .. k)
    return t[k]
  end,
})
