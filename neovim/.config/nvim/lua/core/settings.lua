local settings = {}

-- Set the colorscheme to use here.
-- Available values are: `catppuccin`, `catppuccin-latte`, `catppucin-mocha`, `catppuccin-frappe`, `catppuccin-macchiato`.
---@type string
settings["colorscheme"] = "catppuccin"

-- Set it to true if your terminal has transparent background.
---@type boolean
settings["transparent_background"] = true

-- Set background color to use here.
-- Useful if you would like to use a colorscheme that has a light and dark variant like `edge`.
-- Valid values are: `dark`, `light`.
---@type "dark"|"light"
settings["background"] = "dark"

-- Set the language servers that will be installed during bootstrap here.
-- check the below link for all the supported LSPs:
-- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations
---@type string[]
settings["lsp_servers"] = {
  "bashls",
  "jsonls",
  "yamlls",
  "lua_ls",
  --- FE ---
  -- "tsserver",
  "vtsls",
  "html",
  "cssls",
  "cssmodules_ls",
  "tailwindcss",
  "eslint",
  ----------
}

settings["eslint_format_dir"] = {
  "/work/saas",
  "/motor%-design",
  "/ad_match_mono",
  "/work/blitz",
  "/motor_mp",
  "/ad_basic_pages",
  "/open_platform_admin",
}

-- Set the Treesitter parsers that will be installed during bootstrap here.
-- Check the below link for all supported languages:
-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
---@type string[]
settings["treesitter_parsers"] = {
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
}

return settings
