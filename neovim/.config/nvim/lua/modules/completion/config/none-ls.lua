return function()
  local null_ls = require("null-ls")
  local h = require("null-ls.helpers")
  local u = require("null-ls.utils")

  local builtins = null_ls.builtins

  -- Please set additional flags for the supported servers here
  -- Don't specify any config here if you are using the default one.
  local sources = {
    builtins.formatting.prettier.with({
      filetypes = {
        "vue",
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact",
        "yaml",
        "html",
        "css",
        "scss",
        "less",
        "sh",
        "markdown",
        "json",
        "graphql",
      },
      condition = function(utils)
        return (not utils.root_matches("saas"))
            and (not utils.root_matches("dealer"))
            and (not utils.root_matches('motor%-design'))
        -- change file extension if you use something else
      end,
    }),
    -- builtins.formatting.eslint.with({
    --   cwd = h.cache.by_bufnr(function(params)
    --     return u.root_pattern(
    --     -- https://eslint.org/docs/latest/user-guide/configuring/configuration-files-new
    --       "eslint.config.js",
    --       -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
    --       ".eslintrc",
    --       ".eslintrc.js",
    --       ".eslintrc.cjs",
    --       ".eslintrc.yaml",
    --       ".eslintrc.yml",
    --       ".eslintrc.json",
    --       "package.json"
    --     )(params.bufname)
    --   end),
    --   condition = function(utils)
    --     return utils.root_matches("dealer") -- change file extension if you use something else
    --   end,
    -- }),

    builtins.formatting.rustfmt,

    builtins.formatting.goimports,
    builtins.formatting.gofumpt,

    -- npm install -g eslint_d eslint
    -- builtins.diagnostics.eslint.with({
    --   diagnostics_format = '[eslint] #{m}\n(#{c})',
    --   cwd = h.cache.by_bufnr(function(params)
    --     return u.root_pattern(
    --     -- https://eslint.org/docs/latest/user-guide/configuring/configuration-files-new
    --       "eslint.config.js",
    --       -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
    --       ".eslintrc",
    --       ".eslintrc.js",
    --       ".eslintrc.cjs",
    --       ".eslintrc.yaml",
    --       ".eslintrc.yml",
    --       ".eslintrc.json",
    --       "package.json"
    --     )(params.bufname)
    --   end),
    --   -- only enable eslint if root has .eslintrc.js
    --   -- condition = function(utils)
    --   --   return utils.root_has_file(".eslintrc.js") -- change file extension if you use something else
    --   -- end,
    -- }),

    -- builtins.code_actions.eslint_d.with({
    --   cwd = h.cache.by_bufnr(function(params)
    --     return u.root_pattern(
    --     -- https://eslint.org/docs/latest/user-guide/configuring/configuration-files-new
    --       "eslint.config.js",
    --       -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
    --       ".eslintrc",
    --       ".eslintrc.js",
    --       ".eslintrc.cjs",
    --       ".eslintrc.yaml",
    --       ".eslintrc.yml",
    --       ".eslintrc.json",
    --       "package.json"
    --     )(params.bufname)
    --   end),
    -- }),
    builtins.code_actions.gomodifytags,
    builtins.code_actions.impl,

  }
  null_ls.setup({
    border = "rounded",
    -- debug = true,
    -- log_level = "warn",
    -- update_in_insert = false,
    sources = sources,
    -- #{m}: message
    -- #{s}: source name (defaults to null-ls if not specified)
    -- #{c}: code (if available)
    diagnostics_format = "[#{s}] #{m}",
  })

  require("completion.config.format").setup()
end
