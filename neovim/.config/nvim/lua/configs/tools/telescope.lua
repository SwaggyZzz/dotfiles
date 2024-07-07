return function()
  local telescope = require "telescope"
  local actions = require "telescope.actions"
  -- local lga_actions = require "telescope-live-grep-args.actions"

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
      prompt_prefix = "   ",
      selection_caret = " ",
      entry_prefix = "  ",
      initial_mode = "insert",
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
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = { "node_modules" },
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      path_display = { "truncate" },
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
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

    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      -- live_grep_args = {
      --   auto_quoting = true, -- enable/disable auto-quoting
      --   -- define mappings, e.g.
      --   mappings = { -- extend mappings
      --     i = {
      --       ["<C-k>"] = lga_actions.quote_prompt(),
      --       ["<C-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
      --     },
      --   },
      -- },
    },
  }

  telescope.setup(opts)

  telescope.load_extension "fzf"
  -- telescope.load_extension "live_grep_args"
end
