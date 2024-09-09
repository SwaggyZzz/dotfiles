local M = {}

function M.find_files_by_path()
  local telescope = require("telescope.builtin")
  local success, path = pcall(vim.fn.input("查找路径: ", vim.fn.getcwd())) -- 获取当前工作目录作为默认路径
  if path == nil or not success then
    return
  end
  telescope.find_files({
    cwd = path,
    hidden = true,
  })
end

function M.get_neo_tree_telescope_opts(state, path)
  return {
    cwd = path,
    search_dirs = { path },
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if filename == nil then
          filename = selection[1]
        end
        -- any way to open the file without triggering auto-close event of neo-tree?
        require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
      end)
      return true
    end,
  }
end

return M
