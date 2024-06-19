return {
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		opts = function()
			return {
				override = {
					default_icon = {
						icon = "󰈚",
						name = "Default",
					},

					c = {
						icon = "",
						name = "c",
					},

					css = {
						icon = "",
						name = "css",
					},

					dart = {
						icon = "",
						name = "dart",
					},

					deb = {
						icon = "",
						name = "deb",
					},

					Dockerfile = {
						icon = "",
						name = "Dockerfile",
					},

					html = {
						icon = "",
						name = "html",
					},

					jpeg = {
						icon = "󰉏",
						name = "jpeg",
					},

					jpg = {
						icon = "󰉏",
						name = "jpg",
					},

					js = {
						icon = "󰌞",
						name = "js",
					},

					kt = {
						icon = "󱈙",
						name = "kt",
					},

					lock = {
						icon = "󰌾",
						name = "lock",
					},

					lua = {
						icon = "",
						name = "lua",
					},

					mp3 = {
						icon = "󰎆",
						name = "mp3",
					},

					mp4 = {
						icon = "",
						name = "mp4",
					},

					out = {
						icon = "",
						name = "out",
					},

					png = {
						icon = "󰉏",
						name = "png",
					},

					py = {
						icon = "",
						name = "py",
					},

					["robots.txt"] = {
						icon = "󰚩",
						name = "robots",
					},

					toml = {
						icon = "",
						name = "toml",
					},

					ts = {
						icon = "󰛦",
						name = "ts",
					},

					ttf = {
						icon = "",
						name = "TrueTypeFont",
					},

					rb = {
						icon = "",
						name = "rb",
					},

					rpm = {
						icon = "",
						name = "rpm",
					},

					vue = {
						icon = "󰡄",
						name = "vue",
					},

					woff = {
						icon = "",
						name = "WebOpenFontFormat",
					},

					woff2 = {
						icon = "",
						name = "WebOpenFontFormat2",
					},

					xz = {
						icon = "",
						name = "xz",
					},

					zip = {
						icon = "",
						name = "zip",
					},
				},
			}
		end,
	},
	{ "MunifTanjim/nui.nvim", lazy = true },
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		config = require("configs.ui.catppuccin"),
	},
	{
		"nvimdev/dashboard-nvim",
		lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
		config = require("configs.ui.dashboard"),
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		lazy = true,
		main = "ibl",
		event = { "CursorHold", "CursorHoldI" },
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = {
				enabled = true,
				char = "┃",
				show_start = false,
				show_end = false,
			},
			exclude = {
				filetypes = {
					"", -- for all buffers without a file type
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
					"NvimTree",
					"fugitive",
					"git",
					"gitcommit",
					"help",
					"json",
					"log",
					"markdown",
				},
			},
		},
		config = function(_, opts)
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
			require("ibl").setup(opts)
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				-- signature = {
				--   enabled = false,
				-- },
				-- hover = {
				--   enabled = false,
				-- }
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
				{
					filter = {
						event = "notify",
						find = "No information available",
					},
					opts = { skip = true },
				},
			},
			presets = {
				bottom_search = false,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
			},
		},
	},
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		opts = {
			stages = "static",
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
		config = function(_, opts)
			local notify = require("notify")
			notify.setup(opts)
			vim.notify = notify
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		config = require("configs.tools.gitsigns"),
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"meuter/lualine-so-fancy.nvim",
		},
		opts = function()
			return {
				options = {
					theme = "catppuccin",
					-- component_separators = { left = "│", right = "│" },
					-- section_separators = { left = "", right = "" },
					component_separators = "",
					section_separators = { left = "", right = "" },
					globalstatus = true,
					refresh = {
						statusline = 100,
					},
				},
				sections = {
					lualine_a = {
						{ "fancy_mode", width = 6 },
					},
					lualine_b = {
						{ "fancy_branch" },
						{ "fancy_diff" },
					},
					lualine_c = {
						{ "fancy_cwd", substitute_home = true },
					},
					lualine_x = {
						{ "fancy_diagnostics" },
						{ "fancy_searchcount" },
						{ "fancy_location" },
					},
					lualine_y = {
						{ "fancy_filetype", ts_icon = "" },
					},
					lualine_z = {
						{ "fancy_lsp_servers", split = "|" },
					},
				},
				extensions = { "nvim-tree", "neo-tree", "lazy", "quickfix", "trouble" },
			}
		end,
	},
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		config = require("configs.ui.bufferline"),
	},
}
