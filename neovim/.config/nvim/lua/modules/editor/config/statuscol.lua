return function()
  local builtin = require("statuscol.builtin")
  require("statuscol").setup({
    ft_ignore = {
      "DiffviewFileHistory",
      "DiffviewFiles",
      "NvimTree",
      "TelescopePrompt",
      "TelescopeResults",
      "Trouble",
      "dap-repl",
      "dapui_breakpoints",
      "dapui_console",
      "dapui_scopes",
      "dapui_stacks",
      "dapui_watches",
      "help",
      "lazy",
      "lazyterm",
      "leetcode.nvim",
      "lspinfo",
      "mason",
      "neo-tree",
      "notify",
      "oil",
      "qf",
      "terminal",
      "toggleterm",
      "trouble",
      "vim",
      "alpha"
    },
    bt_ignore = {
      "terminal",
      "nofile",
      "alpha"
    },

    relculright = true,
    segments = {
      {
        text = { " " },
        condition = { true },
      },
      {
        sign = { name = { "Dap*" }, namespace = { "bulb*" } },
        click = "v:lua.ScSa",
      },
      {
        text = { builtin.lnumfunc, " " },
        condition = { true, builtin.not_empty },
        click = "v:lua.ScLa",
      },
      {
        sign = { namespace = { "gitsign*" }, colwidth = 1 },
        -- click = "v:lua.ScSa",
      },
      {
        text = { builtin.foldfunc, "  " },
        condition = { true, builtin.not_empty },
        -- click = "v:lua.ScFa",
      },
    }
  })
end
