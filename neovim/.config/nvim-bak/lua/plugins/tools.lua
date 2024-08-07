return {
  { "nvim-lua/plenary.nvim" },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {
      preset = "modern",
      win = { border = "rounded" }
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    version = "*",
    config = require("configs.tools.nvim-tree"),
  },
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "numToStr/Navigator.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "ojroques/nvim-bufdel",
    lazy = true,
    cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
	  keys = {
	    { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
	    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
	    { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
	  },
  },
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = "Telescope",
    config = require("configs.tools.telescope"),
    dependencies = {
      -- { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    opts = {
      focus = true,
    },
    keys = {
    	{ "<leader>xx", "<CMD>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
    	{ "<leader>xd", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
    	{ "<leader>xl", "<CMD>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
    	{ "<leader>xq", "<CMD>Trouble quickfix toggle<CR>", desc = "Quickfix List (Trouble)" },
      { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Todos (Trouble)" },
    	{
    		"[q",
    		function()
    			if require("trouble").is_open() then
    				require("trouble").prev({ skip_groups = true, jump = true })
    			else
    				local ok, err = pcall(vim.cmd.cprev)
    				if not ok then
    					vim.notify(err, vim.log.levels.ERROR)
    				end
    			end
    		end,
    		desc = "Previous Trouble/Quickfix Item",
    	},
    	{
    		"]q",
    		function()
    			if require("trouble").is_open() then
    				require("trouble").next({ skip_groups = true, jump = true })
    			else
    				local ok, err = pcall(vim.cmd.cnext)
    				if not ok then
    					vim.notify(err, vim.log.levels.ERROR)
    				end
    			end
    		end,
    		desc = "Next Trouble/Quickfix Item",
    	},
    },
  },
}
