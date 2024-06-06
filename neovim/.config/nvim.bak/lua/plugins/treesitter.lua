return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "fish",
        "go",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "toml",
        "kdl",
        -- FE Start---
        "tsx",
        "typescript",
        "javascript",
        "html",
        "css",
        "scss",
        "vue",
        "graphql",
        "json",
        "svelte",
        -- FE End---
        "gitcommit",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- MDX
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    -- enabled = false
  }
}
