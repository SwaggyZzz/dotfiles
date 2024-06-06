return function(_, opts)
  local opts = {
    formatters_by_ft = {
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      less = { "prettier" },
      svelte = { "prettier" },
      graphql = { "prettier" },
      json = { "prettier" },
      markdown = { "prettier" },
      yaml = { "prettier" },
      lua = { "stylua" },
      sh = { "shfmt" },
    },
    -- The options you set here will be merged with the builtin formatters.
    -- You can also define any custom formatters here.
    ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
    formatters = {
      injected = { options = { ignore_errors = true } },
      prettier = {
        condition = function(_, ctx)
          -- vim.notify('======' .. ctx.dirname)
          -- for key, value in pairs(ctx) do
          --   vim.notify('======' .. key ..'===='..type(value))
          -- end
          -- return vim.fs.basename(ctx.filename) ~= "README.md"

          return not vim.fs.find(
            {
              "saas",
              "motor%-design",
              "ad_match_mono"
            },
            {
              type = "directory",
              path = ctx.dirname,
              upward = true
            })[1]
        end,
      }
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
  }

  require("conform").setup(opts)
end
