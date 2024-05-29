-- return {
--   {
--     "nvim-treesitter/nvim-treesitter",
--     build = ":TSUpdate",
--     lazy = true,
--     event = "BufReadPre",
--     cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
--     ---@type TSConfig
--     ---@diagnostic disable-next-line: missing-fields
--     opts = {
--       highlight = { enable = true },
--       indent = { enable = true },
--       ensure_installed = {
--         "bash",
--         "c",
--         "cpp",
--         "fish",
--         "go",
--         "lua",
--         "luadoc",
--         "make",
--         "markdown",
--         "markdown_inline",
--         "python",
--         "rust",
--         "toml",
--         "kdl",
--         -- FE Start---
--         "tsx",
--         "typescript",
--         "javascript",
--         "html",
--         "css",
--         "scss",
--         "vue",
--         "graphql",
--         "json",
--         "svelte",
--         -- FE End---
--         "gitcommit",
--         "vim",
--         "vimdoc",
--         "yaml",
--       },
--       textobjects = {
--         move = {
--           enable = true,
--           goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
--           goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
--           goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
--           goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
--         },
--       },
--     },
--     ---@param opts TSConfig
--     config = function(_, opts)
--       require("nvim-treesitter.configs").setup(opts)
--     end,
--   },

--   {
--     "windwp/nvim-ts-autotag",
--     lazy = true,
--     event = "BufReadPre",
--     opts = {},
--   },
-- }


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
  },
}