local settings = {}

-- Set it to false if you don't use nvim to open big files.
---@type boolean
settings["load_big_files_faster"] = true

-- Change the colors of the global palette here.
-- Settings will complete their replacement at initialization.
-- Parameters will be automatically completed as you type.
-- Example: { sky = "#04A5E5" }
---@type palette[]
settings["palette_overwrite"] = {}

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

-- Set the command for handling external URLs here. The executable must be available on your $PATH.
-- This entry is IGNORED on Windows and macOS, which have their default handlers builtin.
---@type string
settings["external_browser"] = "chrome-cli open"

-- Filetypes in this list will skip lsp formatting if rhs is true.
---@type table<string, boolean>
settings["formatter_block_list"] = {
  lua = false, -- example
}

-- Servers in this list will skip setting formatting capabilities if rhs is true.
---@type table<string, boolean>
settings["server_formatting_block_list"] = {
  lua_ls = true,
  tsserver = true,
  clangd = true,
}

-- Set the language servers that will be installed during bootstrap here.
-- check the below link for all the supported LSPs:
-- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations
---@type string[]
settings["lsp_deps"] = {
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
  --- -- ---
}

-- Set the Treesitter parsers that will be installed during bootstrap here.
-- Check the below link for all supported languages:
-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
---@type string[]
settings["treesitter_deps"] = {
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
