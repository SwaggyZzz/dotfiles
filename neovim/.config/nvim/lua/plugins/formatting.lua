return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        prettier = {
          condition = function(_, ctx)
            -- vim.notify('======' .. ctx.dirname)
            -- for key, value in pairs(ctx) do
            --   vim.notify('======' .. key ..'===='..type(value))
            -- end
            -- return vim.fs.basename(ctx.filename) ~= "README.md"

            return not vim.fs.find({
              "saas",
              "motor%-design",
              "ad_match_mono",
              "blitz",
            }, {
              type = "directory",
              path = ctx.dirname,
              upward = true,
            })[1]
          end,
        },
        -- # Example of using dprint only when a dprint.json file is present
        -- dprint = {
        --   condition = function(ctx)
        --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
        --
        -- # Example of using shfmt with extra args
        -- shfmt = {
        --   prepend_args = { "-i", "2", "-ci" },
        -- },
      },
    },
  },
}
