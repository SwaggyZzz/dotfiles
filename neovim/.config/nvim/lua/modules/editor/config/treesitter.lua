return vim.schedule_wrap(function()
	-- vim.api.nvim_set_option_value("foldmethod", "expr", {})
	-- vim.api.nvim_set_option_value("foldexpr", "nvim_treesitter#foldexpr()", {})

  require("nvim-treesitter.configs").setup({
		ensure_installed = require("core.settings").treesitter_deps,
		highlight = {
			enable = true,
			-- disable = function(ft, bufnr)
			-- 	if vim.tbl_contains({ "vim" }, ft) then
			-- 		return true
			-- 	end

			-- 	local ok, is_large_file = pcall(vim.api.nvim_buf_get_var, bufnr, "bigfile_disable_treesitter")
			-- 	return ok and is_large_file
			-- end,
			-- additional_vim_regex_highlighting = false,
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
	})
	require("nvim-treesitter.install").prefer_git = true
end)
