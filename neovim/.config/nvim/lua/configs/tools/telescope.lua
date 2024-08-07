return function()
  local opts = {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      initial_mode = "insert",
      prompt_prefix = "   ",
      selection_caret = " ",
      entry_prefix = "  ",
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      path_display = { "truncate" },
      winblend = 0, -- 0-100 0-完全不透明
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = { ".git/", ".cache", "%.pdf", "%.mkv", "%.mp4", "%.zip" },
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
      mappings = {
        i = {
          ["<C-u>"] = false, -- clear the prompt on <C-u> rather than scroll the previewer
          -- ["<Tab>"] = actions.move_selection_next,
          -- ["<S-Tab>"] = actions.move_selection_previous,
          -- ["<C-Down>"] = actions.cycle_history_next,
          -- ["<C-Up>"] = actions.cycle_history_prev,
          -- ["<C-f>"] = actions.preview_scrolling_down,
          -- ["<C-b>"] = actions.preview_scrolling_up,
        },
        n = { ["q"] = require("telescope.actions").close },
      },
    },

    pickers = {
      find_files = {
        find_command = { "rg", "--files", "--color", "never", "-g", "!.git" },
        hidden = true,
      },
    },

    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  }
  require("telescope").setup(opts)
  require("telescope").load_extension("fzf")
end
