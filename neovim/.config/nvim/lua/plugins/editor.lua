return {
  {
    "nvimdev/hlsearch.nvim",
    lazy = true,
    event = "BufRead",
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {
      modes = {
        -- options used when flash is activated through
        -- a regular search with `/` or `?`
        search = {
          -- when `true`, flash will be activated during regular search by default.
          -- You can always toggle when searching with `require("flash").toggle()`
          enabled = true,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      mappings = {
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } },
      },
    },
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "CursorHold", "CursorHoldI" },
    opts = {
      highlight = {
        exclude = { "big_file_disabled_ft", "checkhealth" },
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    opts = {},
    -- keys = {
    -- 	{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    -- 	{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
    -- 	{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
    -- 	{
    -- 		"<leader>cS",
    -- 		"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    -- 		desc = "LSP references/definitions/... (Trouble)",
    -- 	},
    -- 	{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    -- 	{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    -- 	{
    -- 		"[q",
    -- 		function()
    -- 			if require("trouble").is_open() then
    -- 				require("trouble").prev({ skip_groups = true, jump = true })
    -- 			else
    -- 				local ok, err = pcall(vim.cmd.cprev)
    -- 				if not ok then
    -- 					vim.notify(err, vim.log.levels.ERROR)
    -- 				end
    -- 			end
    -- 		end,
    -- 		desc = "Previous Trouble/Quickfix Item",
    -- 	},
    -- 	{
    -- 		"]q",
    -- 		function()
    -- 			if require("trouble").is_open() then
    -- 				require("trouble").next({ skip_groups = true, jump = true })
    -- 			else
    -- 				local ok, err = pcall(vim.cmd.cnext)
    -- 				if not ok then
    -- 					vim.notify(err, vim.log.levels.ERROR)
    -- 				end
    -- 			end
    -- 		end,
    -- 		desc = "Next Trouble/Quickfix Item",
    -- 	},
    -- },
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
  },
}
