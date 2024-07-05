local M = {
  treesitter_parsers = {
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
  },
  lsp_servers = {
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
  },
  eslint_format_dir = {
    "/work/saas",
    "/motor-design",
    "/ad_match_mono",
    "/work/blitz",
    "/motor_mp",
    "ad_basic_pages",
  }
}

return M
