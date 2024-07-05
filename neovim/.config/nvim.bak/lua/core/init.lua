local settings = require("core.settings")

local leader_map = function()
	vim.g.mapleader = " "
	-- NOTE:
	--  > Uncomment the following if you're using a <leader> other than <Space>, and you wish
	--  > to disable advancing one character by pressing <Space> in normal/visual mode.
	-- vim.api.nvim_set_keymap("n", " ", "", { noremap = true })
	-- vim.api.nvim_set_keymap("x", " ", "", { noremap = true })
end

local clipboard_config = function()
	if global.is_mac then
		vim.g.clipboard = {
			name = "macOS-clipboard",
			copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
			paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
			cache_enabled = 0,
		}
	elseif global.is_wsl then
		vim.g.clipboard = {
			name = "win32yank-wsl",
			copy = {
				["+"] = "win32yank.exe -i --crlf",
				["*"] = "win32yank.exe -i --crlf",
			},
			paste = {
				["+"] = "win32yank.exe -o --lf",
				["*"] = "win32yank.exe -o --lf",
			},
			cache_enabled = 0,
		}
	end
end

local load_core = function()
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1


	leader_map()
	-- clipboard_config()

	require("core.options")
	require("core.mappings")
	require("core.events")
	require("core.lazy")
	-- require("core.pack")

	local background = settings.background
	local colorscheme = settings.colorscheme
	vim.api.nvim_command("set background=" .. background)
	vim.api.nvim_command("colorscheme " .. colorscheme)
end

load_core()
