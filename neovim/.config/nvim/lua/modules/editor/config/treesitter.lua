return function()
  local status, ts = pcall(require, "nvim-treesitter.configs")
  if (not status) then return end

  -- vim.api.nvim_set_option_value("foldmethod", "expr", {})
  -- vim.api.nvim_set_option_value("foldexpr", "nvim_treesitter#foldexpr()", {})


  ts.setup({
    highlight = {
      enable = true,
      disable = function(lang, buf)
        if vim.tbl_contains({ "latex" }, lang) then
          return true
        end

        local max_filesize = 150 * 1024 -- 150 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    matchup = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "fish",
      "go",
      "gomod",
      "lua",
      "luadoc",
      "make",
      "markdown",
      "markdown_inline",
      "python",
      "rust",
      "toml",
      -- FE ---
      "tsx",
      "typescript",
      "javascript",
      "html",
      "css",
      "vue",
      "graphql",
      "json",
      "svelte",
      -- FE ---
      "gitcommit",
      "vim",
      "vimdoc",
      "yaml",
    },
  })

  -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1111#issuecomment-1216655480
  -- local treesitterFix = require("editor.config.treesitter-css-in-js")
  -- treesitterFix.directives()
  -- treesitterFix.queries()
end
