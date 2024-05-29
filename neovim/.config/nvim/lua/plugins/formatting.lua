return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = function(_, opts)
      opts.formatters.prettier = {
        condition = function(_, ctx)
          -- vim.notify('======' .. ctx.dirname)
          -- for key, value in pairs(ctx) do
          --   vim.notify('======' .. key ..'===='..type(value))
          -- end
          -- return vim.fs.basename(ctx.filename) ~= "README.md"

          return not vim.fs.find(
            {
              "saas",
              "motor%-design"
            },
            {
              type = "directory",
              path = ctx.dirname,
              upward = true
            })[1]
        end,
      }
      return opts
    end
  }
}