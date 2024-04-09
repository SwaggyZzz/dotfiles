local M = {}

M.setup = function()
  local mason = require("mason")
  mason.setup({
    ui = {
      border = "rounded",
    },
  })
end

return M
