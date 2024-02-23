return function()
  local icons = require("swaggyz.new-icons")

  local HEIGHT_RATIO = 0.8 -- You can change this
  local WIDTH_RATIO = 0.5  -- You can change this too

  local function on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- BEGIN_DEFAULT_ON_ATTACH
    vim.keymap.set('n', 'l', api.node.open.edit, opts('edit'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('parent close'))
    vim.keymap.set('n', 'v', api.node.open.vertical, opts('open vertical'))
    vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
    vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
    vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
    vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
    vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
    vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
    vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
    vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
    vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
    vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
    vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))
    vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
    -- vim.keymap.set('n', 'bd', api.marks.bulk.delete, opts('Delete Bookmarked'))
    -- vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
    vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
    vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
    vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
    vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
    vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
    vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
    vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
    vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
    vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
    vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
    vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
    vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
    vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
    vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
    vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
    vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
    vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
    vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
    vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
    vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
    vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
    vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
    vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
    vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
    vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
    -- vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
    -- vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
    vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
    vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
    vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
    vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
    vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
    vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
    -- -- END_DEFAULT_ON_ATTACH
  end

  require("nvim-tree").setup({
    auto_reload_on_write = false,
    disable_netrw = false,
    hijack_cursor = false,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    sort_by = "name",
    root_dirs = {},
    prefer_startup_root = false,
    -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
    sync_root_with_cwd = true,
    reload_on_bufenter = false,
    --false by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree
    respect_buf_cwd = true,
    select_prompts = false,
    on_attach = on_attach,
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      debounce_delay = 50,
      icons = {
        hint = icons.diagnostics.BoldHint,
        info = icons.diagnostics.BoldInformation,
        warning = icons.diagnostics.BoldWarning,
        error = icons.diagnostics.BoldError,
      },
    },
    -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
    update_focused_file = {
      -- enables the feature
      enable = true,
      -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
      -- only relevant when `update_focused_file.enable` is true
      update_root = true,
      -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
      -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
      ignore_list = {},
    },
    git = {
      enable = true,
    },
    filesystem_watchers = {
      enable = true,
      debounce_delay = 50,
    },
    filters = {
      -- hide dot files
      dotfiles = false,
      -- Ignore files based on `.gitignore`
      git_ignored = false,
      -- hide node_modules folder
      custom = { "node_modules", "\\.cache" },
    },
    view = {
      width = 40,
      -- width = function()
      --   return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
      -- end,
      side = "left",
      number = false,
      relativenumber = false,
      signcolumn = "yes",
      -- When entering nvim-tree, reposition the view so that the current node is initially centralized
      centralize_selection = true,
      -- float = {
      --   enable = true,
      --   open_win_config = function()
      --     local screen_w = vim.opt.columns:get()
      --     local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
      --     local window_w = screen_w * WIDTH_RATIO
      --     local window_h = screen_h * HEIGHT_RATIO
      --     local window_w_int = math.floor(window_w)
      --     local window_h_int = math.floor(window_h)
      --     local center_x = (screen_w - window_w) / 2
      --     local center_y = ((vim.opt.lines:get() - window_h) / 2)
      --         - vim.opt.cmdheight:get()
      --     return {
      --       border = "rounded",
      --       relative = "editor",
      --       row = center_y,
      --       col = center_x,
      --       width = window_w_int,
      --       height = window_h_int,
      --     }
      --   end,
      -- },
    },
    actions = {
      use_system_clipboard = true,
      change_dir = {
        enable = true,
        global = false,
        restrict_above_cwd = false,
      },
      open_file = {
        -- if true the tree will resize itself after opening a file
        resize_window = false,
        quit_on_open = false,
        window_picker = {
          enable = true,
          chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
          exclude = {
            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
            buftype = { "nofile", "terminal", "help" },
          },
        },
      },
    },
    renderer = {
      group_empty = false, -- 文件夹下只有一个文件夹的时候是否合并展示
      highlight_git = true,
      -- root_folder_label = ":~",
      root_folder_label = ":t",
      indent_width = 2,
      indent_markers = {
        enable = true,
        icons = {
          corner = "└ ",
          edge = "│ ",
          item = "│ ",
          none = "  ",
        },
      },
      icons = {
        webdev_colors = true,
        git_placement = "after", -- before | after | signcolumn
        diagnostics_placement = "signcolumn",
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
          modified = true,
        },
        padding = " ",
        symlink_arrow = " 󰁔 ",
        glyphs = {
          default = icons.ui.Text,        --
          symlink = icons.ui.FileSymlink, --
          bookmark = icons.ui.BookMark,
          git = {
            unstaged = icons.git.FileUnstaged,
            staged = icons.git.FileStaged,
            unmerged = icons.git.FileUnmerged,
            renamed = icons.git.FileRenamed,
            untracked = icons.git.FileUntracked,
            deleted = icons.git.FileDeleted,
            ignored = icons.git.FileIgnored,
          },
          folder = {
            arrow_open = icons.ui.TriangleShortArrowDown,
            arrow_closed = icons.ui.TriangleShortArrowRight,
            default = icons.ui.Folder,
            open = icons.ui.FolderOpen,
            empty = icons.ui.EmptyFolder,
            empty_open = icons.ui.EmptyFolderOpen,
            symlink = icons.ui.FolderSymlink,
            symlink_open = icons.ui.FolderOpen,
          },
        },
      },
      special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
      symlink_destination = true,
    },
  })
end
