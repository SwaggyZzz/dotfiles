return function ()
   local icons = require("core.icons")

  require("neo-tree").setup({
    sources = { "filesystem"},
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          "node_modules",
          ".husky",
          ".vscode",
        },
        never_show = {
          ".DS_Store",
          "thumb.db",
          ".git",
        },
      },
    },
    window = {
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none",
        ["Y"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
          desc = "Copy Path to Clipboard",
        },
        ["P"] = { "toggle_preview", config = { use_float = false } },
      },
    },
    default_component_configs = {
      indent = {
        -- expander config, needed for nesting files
        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = icons.ui.TriangleShortArrowRight,
        expander_expanded = icons.ui.TriangleShortArrowDown,
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = icons.ui.Folder,
        folder_open = icons.ui.FolderOpen,
        folder_empty = icons.ui.EmptyFolder,
      },
      git_status = {
        symbols = {
          untracked = icons.git.FileUntracked,
          ignored   = icons.git.FileIgnored,
          unstaged  = icons.git.FileUnstaged,
          staged    = icons.git.FileStaged,
          conflict  = icons.git.FileConflict,
        }
      },
    }
  })
end