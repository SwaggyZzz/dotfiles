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

return M
