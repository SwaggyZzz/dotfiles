return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    dependencies = { "mason.nvim" },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          require("utils.format").register({
            name = "conform.nvim",
            priority = 100,
            primary = true,
            format = function(buf)
              local format_opts = require("core.settings").conform_format_opts
              ---@diagnostic disable-next-line: undefined-field
              require("conform").format(vim.tbl_deep_extend(
                "force",
                {},
                format_opts,
                { bufnr = buf }
              ))
            end,
            sources = function(buf)
              local ret = require("conform").list_formatters(buf)
              ---@param v conform.FormatterInfo
              return vim.tbl_map(function(v)
                return v.name
              end, ret)
            end,
          })
        end,
      })
    end,
    opts = function()
      ---@class ConformOpts
      local opts = {
        formatters_by_ft = {
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
                  "motor%-design"
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
      return opts
    end,
    config = require("configs.conform"),
  }
}
