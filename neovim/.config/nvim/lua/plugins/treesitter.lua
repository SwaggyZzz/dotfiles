return {
  {
    "nvim-treesitter/nvim-treesitter",
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>",      desc = "Decrement Selection", mode = "x" },
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "fish",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "toml",
        "kdl",
        --- FE ---
        "tsx",
        "typescript",
        "javascript",
        "html",
        "css",
        "vue",
        "graphql",
        "json",
        "svelte",
        ----------
        "gitcommit",
        "vim",
        "vimdoc",
        "yaml",
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      {
        "NvChad/nvim-colorizer.lua",
      },
      {
        "windwp/nvim-ts-autotag",
      }
    },
  }
}
