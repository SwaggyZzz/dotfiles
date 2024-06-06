return function()
  local icons = { ui = require("utils.icons").get("ui", true) }
  local actions = require("telescope.actions")
  local lga_actions = require("telescope-live-grep-args.actions")

  local opts = {
    defaults = {
      vimgrep_arguments    = {
        "rg",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      prompt_prefix        = " " .. icons.ui.Telescope .. " ",
      selection_caret      = icons.ui.ChevronRight,
      path_display         = { "smart" },
      file_ignore_patterns = { ".git/", ".cache", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip" },
      layout_config        = {
        horizontal = {
          preview_cutoff = 120,
        },
        -- prompt_position = "top",
      },
      -- open files in the first window that is an actual file.
      -- use the current window if no other window is available.
      get_selection_window = function()
        local wins = vim.api.nvim_list_wins()
        table.insert(wins, 1, vim.api.nvim_get_current_win())
        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == "" then
            return win
          end
        end
        return 0
      end,
      mappings             = {
        n = {
          ["q"] = actions.close,
        },
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        -- define mappings, e.g.
        mappings = {     -- extend mappings
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          },
        },
      },
    },
  }

  require("telescope").setup(opts)

  require("telescope").load_extension("fzf")
  require("telescope").load_extension("live_grep_args")
end
