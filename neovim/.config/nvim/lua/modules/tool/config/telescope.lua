---@alias telescope_themes
---| "cursor"   # see `telescope.themes.get_cursor()`
---| "dropdown" # see `telescope.themes.get_dropdown()`
---| "ivy"      # see `telescope.themes.get_ivy()`
---| "center"   # retain the default telescope theme

return function()
  local icons = require('swaggyz.new-icons')
  local actions = require("telescope.actions")
  local previewers = require("telescope.previewers")
  local sorters = require("telescope.sorters")

  local opts = {
    defaults = {
      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = icons.ui.Forward .. " ",
      initial_mode = "insert",
      selection_strategy = "reset",
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },
      mappings = {
        n = {
          ["q"] = function(...)
            return actions.close(...)
          end,
        },
      },
      path_display = { "smart" },
      file_ignore_patterns = { ".git/", ".cache", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip" },
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      -- layout_config = {
      --   horizontal = {
      --     preview_width = 0.5,
      --   },
      -- },
      file_previewer = previewers.vim_buffer_cat.new,
      grep_previewer = previewers.vim_buffer_vimgrep.new,
      qflist_previewer = previewers.vim_buffer_qflist.new,
      file_sorter = sorters.get_fuzzy_file,
      generic_sorter = sorters.get_generic_fuzzy_sorter,
    },
    pickers = {
      find_files = {
        hidden = true,
      },
      live_grep = {
        --@usage don't include the filename in the search results
        only_sort_text = true,
      },
      grep_string = {
        only_sort_text = true,
      },
      buffers = {
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },
      planets = {
        show_pluto = true,
        show_moon = true,
      },
      git_files = {
        hidden = true,
        show_untracked = true,
      },
      colorscheme = {
        enable_preview = true,
      },
    },
    extensions = {
      fzf = {
        fuzzy = true, -- 模糊匹配
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  }

  local theme = "dropdown"
  local themeHandler = require("telescope.themes")["get_" .. (theme or "")]

  if theme then
    opts.defaults = themeHandler(opts.defaults)
  end

  require("telescope").setup(opts)

  pcall(function()
    require("telescope").load_extension "fzf"
  end)
end
