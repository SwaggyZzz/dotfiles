local settings = {
  colorscheme = 'catppuccin',
  transparent_background = true,
  background = 'dark',
  lsp_servers = {
    'bashls',
    'jsonls',
    'yamlls',
    'lua_ls',
    'pyright',
    'gopls',
    'thriftls',
    'rust_analyzer',
    'vtsls',
    'svelte',
    'html',
    -- "emmet_ls",
    'cssls',
    'cssmodules_ls',
    'tailwindcss',
    'eslint',
  },
  treesitter_parsers = {
    'bash',
    'c',
    'cpp',
    'fish',
    'thrift',
    'go',
    'gomod',
    'gowork',
    'gosum',
    'lua',
    'luadoc',
    'make',
    'markdown',
    'markdown_inline',
    'python',
    'rust',
    'toml',
    'kdl',
    -- FE ---
    'tsx',
    'typescript',
    'javascript',
    'html',
    'css',
    'vue',
    'graphql',
    'json',
    'svelte',
    -- FE ---
    'gitcommit',
    'vim',
    'vimdoc',
    'yaml',
  },
  eslint_format_dir = {
    '/work/saas',
    '/motor%-design',
    '/ad_match_mono',
    '/work/blitz',
    '/motor_mp',
    '/ad_basic_pages',
    '/open_platform_admin',
    '/motor%-dzx',
    '/data-biz-platform',
    '/dzx',
  },
}

return settings
