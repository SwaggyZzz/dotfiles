local ok, navic = pcall(require, "nvim-navic")

if ok then
  vim.api.nvim_set_hl(0, "NavicText", { link = "Comment" })
  vim.api.nvim_set_hl(0, "NavicSeparator", { link = "Comment" })

  navic.setup {
    lsp = {
      auto_attach = true,
      preference = nil,
    },
    highlight = true,
    separator = " " .. "" .. " ",
    depth_limit = 0,
    depth_limit_indicator = "..",
    safe_output = true
  }
end
