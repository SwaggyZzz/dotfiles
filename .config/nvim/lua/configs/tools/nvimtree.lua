return function()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  local icons = require("core.icons")

  local map = vim.keymap.set
  local function on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- BEGIN_DEFAULT_ON_ATTACH
    map("n", "l", api.node.open.edit, opts("edit"))
    map("n", "h", api.node.navigate.parent_close, opts("parent close"))
    map("n", "v", api.node.open.vertical, opts("open vertical"))
    map("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
    map("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
    map("n", "<C-k>", api.node.show_info_popup, opts("Info"))
    map("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
    map("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
    map("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
    map("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
    map("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
    map("n", "<CR>", api.node.open.edit, opts("Open"))
    map("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
    map("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
    map("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
    map("n", ".", api.node.run.cmd, opts("Run Command"))
    map("n", "-", api.tree.change_root_to_parent, opts("Up"))
    map("n", "a", api.fs.create, opts("Create"))
    --map('n', 'bd', api.marks.bulk.delete, opts('Delete Bookmarked'))
    --map('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
    map("n", "c", api.fs.copy.node, opts("Copy"))
    map("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
    map("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
    map("n", "]c", api.node.navigate.git.next, opts("Next Git"))
    map("n", "d", api.fs.remove, opts("Delete"))
    map("n", "D", api.fs.trash, opts("Trash"))
    map("n", "E", api.tree.expand_all, opts("Expand All"))
    map("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
    map("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
    map("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
    map("n", "F", api.live_filter.clear, opts("Clean Filter"))
    map("n", "f", api.live_filter.start, opts("Filter"))
    map("n", "g?", api.tree.toggle_help, opts("Help"))
    map("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
    map("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
    map("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
    map("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
    map("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
    map("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
    map("n", "o", api.node.open.edit, opts("Open"))
    map("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
    map("n", "p", api.fs.paste, opts("Paste"))
    map("n", "P", api.node.navigate.parent, opts("Parent Directory"))
    map("n", "q", api.tree.close, opts("Close"))
    map("n", "r", api.fs.rename, opts("Rename"))
    map("n", "R", api.tree.reload, opts("Refresh"))
    --map('n', 's', api.node.run.system, opts('Run System'))
    --map('n', 'S', api.tree.search_node, opts('Search'))
    map("n", "U", api.tree.toggle_custom_filter, opts("Toggle Hidden"))
    map("n", "W", api.tree.collapse_all, opts("Collapse"))
    map("n", "x", api.fs.cut, opts("Cut"))
    map("n", "y", api.fs.copy.filename, opts("Copy Name"))
    map("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
    map("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
    map("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
    -- -- END_DEFAULT_ON_ATTACH
  end

  require("nvim-tree").setup({
    on_attach = on_attach,
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true, -- 移动树形文件浏览器中的光标时，始终将光标定位在文件名的第一个字母上
    hijack_unnamed_buffer_when_opening = true, -- 控制在打开文件时是否占用未命名的缓冲区
    sync_root_with_cwd = false,
    respect_buf_cwd = false,
    update_focused_file = {
      enable = true,
      update_root = false,
    },
    filters = {
      dotfiles = false,
      custom = { ".DS_Store", "^.git$" },
    },
    view = {
      adaptive_size = false,
      side = "left",
      width = {
        min = 35,
        max = 40,
      },
      preserve_window_proportions = true, -- 打开文件时均分当前窗口
    },
    git = {
      enable = true,
    },
    filesystem_watchers = {
      enable = true,
      debounce_delay = 50,
    },
    actions = {
      open_file = {
        resize_window = true,
        window_picker = {
          enable = true,
          picker = require("window-picker").pick_window,
          exclude = {
            filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame", "noice" },
            buftype = { "nofile", "terminal", "help" },
          },
        },
      },
    },
    renderer = {
      -- root_folder_label = ":t",
      root_folder_label = false,
      highlight_git = true,
      highlight_opened_files = "none",

      special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "package.json" },

      indent_markers = {
        enable = true,
      },

      icons = {
        git_placement = "before",
        modified_placement = "after",
        diagnostics_placement = "signcolumn",
        bookmarks_placement = "signcolumn",
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
          modified = true,
          diagnostics = true,
          bookmarks = true,
        },

        glyphs = {
          default = icons.ui.Text,
          symlink = icons.ui.FileSymlink,
          bookmark = icons.ui.BookMark,
          modified = icons.ui.Circle,
          folder = {
            arrow_closed = icons.ui.TriangleShortArrowRight,
            arrow_open = icons.ui.TriangleShortArrowDown,
            default = icons.ui.Folder,
            open = icons.ui.FolderOpen,
            empty = icons.ui.EmptyFolder,
            empty_open = icons.ui.EmptyFolderOpen,
            symlink = icons.ui.FolderSymlink,
            symlink_open = icons.ui.FolderOpen,
          },
          git = {
            unstaged = icons.git.FileUnstaged,
            staged = icons.git.FileStaged,
            unmerged = icons.git.FileUnmerged,
            renamed = icons.git.FileRenamed,
            untracked = icons.git.FileUntracked,
            deleted = icons.git.FileDeleted,
            ignored = icons.git.FileIgnored,
          },
        },
      },
    },
  })
end
