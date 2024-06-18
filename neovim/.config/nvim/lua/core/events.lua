-- auto close NvimTree
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
  pattern = "NvimTree_*",
  callback = function()
    local layout = vim.api.nvim_call_function("winlayout", {})
    if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then
      vim.cmd("confirm quit")
    end
  end
})

-- Autoformat autocmd
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("CodeFormat", {}),
  callback = function(event)
    require("conform").format({
      bufnr = event.buf,
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    })
  end,
})

-- -- Manual format
-- vim.api.nvim_create_user_command("CodeFormat", function()
--   require("conform").format({
--     bufnr = vim.api.nvim_get_current_buf(),
--     lsp_fallback = true,
--     async = false,
--     timeout_ms = 500,
--   })
-- end, { desc = "Format selection or buffer" })
