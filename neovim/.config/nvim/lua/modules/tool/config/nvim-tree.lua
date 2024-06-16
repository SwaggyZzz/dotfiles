return function()
  local icons = {
    diagnostics = require("utils.icons").get("diagnostics"),
    documents = require("utils.icons").get("documents"),
    git = require("utils.icons").get("git"),
    ui = require("utils.icons").get("ui"),
  }

  require("nvim-tree").setup({
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,                      -- 移动树形文件浏览器中的光标时，始终将光标定位在文件名的第一个字母上
    hijack_unnamed_buffer_when_opening = true, -- 控制在打开文件时是否占用未命名的缓冲区
    sync_root_with_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = false,
    },
    filters = {
      dotfiles = false,
      custom = { ".DS_Store" },
    },
    view = {
      adaptive_size = false,
      side = "left",
      width = 40,
      preserve_window_proportions = true,
    },
    git = {
      enable = true,
      ignore = true,
    },
    filesystem_watchers = {
      enable = true,
    },
    actions = {
      open_file = {
        resize_window = true,
      },
    },
    renderer = {
      root_folder_label = false,
      highlight_git = true,
      highlight_opened_files = "none",

      special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "package.json" },

      indent_markers = {
        enable = true,
      },

      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },

        symlink_arrow = " 󰁔 ",
        glyphs = {
          default = icons.documents.Default, --
          symlink = icons.documents.Symlink, --
          bookmark = icons.ui.Bookmark,
          git = {
            unstaged = icons.git.Mod_alt,
            staged = icons.git.Add,    --󰄬
            unmerged = icons.git.Unmerged,
            renamed = icons.git.Rename, --󰁔
            untracked = icons.git.Untracked, -- "󰞋"
            deleted = icons.git.Remove, --
            ignored = icons.git.Ignore, --◌
          },
          folder = {
            arrow_open = icons.ui.ArrowOpen,
            arrow_closed = icons.ui.ArrowClosed,
            -- arrow_open = "",
            -- arrow_closed = "",
            default = icons.ui.Folder,
            open = icons.ui.FolderOpen,
            empty = icons.ui.EmptyFolder,
            empty_open = icons.ui.EmptyFolderOpen,
            symlink = icons.ui.SymlinkFolder,
            symlink_open = icons.ui.FolderOpen,
          },
        },
      },
    }
  })
end
