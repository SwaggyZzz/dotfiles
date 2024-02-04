return function()
  require("telescope").setup({
    defaults = {
      initial_mode = "insert",
      mappings = {
        n = {
          ["q"] = function(...)
            return require("telescope.actions").close(...)
          end,
        },
      },
      prompt_prefix = "  ",
      selection_caret = " ",
      -- scroll_strategy = "limit",
      -- results_title = false,
      -- layout_strategy = "horizontal",
      -- path_display = { "absolute" },
      file_ignore_patterns = { ".git/", ".cache", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip" },
      -- layout_config = {
      --   horizontal = {
      --     preview_width = 0.5,
      --   },
      -- },
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    },
    -- pickers = {
    --   keymaps = {
    --     theme = "dropdown",
    --   },
    -- },
    extensions = {
      fzf = {
        fuzzy = false,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  })

  require("telescope").load_extension("fzf")
end
