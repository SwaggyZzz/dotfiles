local fn, api = vim.fn, vim.api
local uv = require("luv")
local global = require("swaggyz.global")

local vim_path = global.vim_path
local data_dir = global.data_dir

local pack = {}

function pack:load_modules_packages()
  local modules_dir = vim_path .. "/lua/modules"

  -- http://www.shouhuola.com/answer/36442/122788.html
  -- 1、require机制相关的数据和函数
  --   package.path:保存加载外部模块(lua中"模块"和"文件"这两个概念的分界比较含糊，
  --   因为这个值在不同的时刻会扮演不同的角色)的搜索 路径，这种路径是"模板式的路径"，
  --   它里面会包含可替代符号"?",这个符号会被替换，然后lua查找这个文件是否存在，如果存在就会调用其中特定的接 口。典型的值为:
  --   "./?.lua;./?.lc;/usr/local/?/init.lua"
  --   如果lua代码中调用:require("hello.world")
  --   那么lua会依次查找：
  --   ./hello/world.lua ==>这里"hello.world"变成了"hello/world",并替换了模型"./?.lua"
  --   ./hello/world.lc
  --   .....
  --   (这种处理方式和python类似，只不过不需要__init__.py,也有调用python中的__init__.py)
  --   package.path在虚拟机启动的时候设置，如果存在环境变量LUA_PATH，那么就用该环境变量作为
  --   它的值，并把这个环境变量中的";;"替换为luaconf.h中定义的默认值，如果不存在该变量就直接使用
  --   luaconf.h定义的默认值

  --   package.cpath:作用和packag.path一样,但它是用于加载第三方c库的。它的初始值可以通过环境变量
  --   LUA_CPATH来设置

  --   package.loadlib(libname, func):相当与手工打开c库libname, 并导出函数func返回，loadlib其实是ll_loadlib
  package.path = package.path
      .. string.format(";%s", modules_dir .. "/?.lua")

  self.repos = {}

  local list = vim.fs.find('package.lua', { path = modules_dir, type = 'file', limit = 10 })
  if #list == 0 then
    return
  end

  for _, f in pairs(list) do
    local _, pos = f:find(modules_dir)
    f = f:sub(pos - 6, #f - 4)
    require(f)
  end
end

function pack:boot_strap()
  local lazy_path = data_dir .. "lazy/lazy.nvim"

  local state = uv.fs_stat(lazy_path)
  if not state then
    local cmd = '!git clone https://github.com/folke/lazy.nvim ' .. lazy_path
    api.nvim_command(cmd)
  end
  vim.opt.runtimepath:prepend(lazy_path) -- vim.opt.rpt

  local lazy = require('lazy')

  self:load_modules_packages()

  lazy.setup(self.repos, {
    ui = {
      -- a number <1 is a percentage., >1 is a fixed size
      size = { width = 0.88, height = 0.8 },
      wrap = true, -- wrap the lines in the ui
      -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
      border = "rounded",
    },
    install = {
      -- install missing plugins on startup. This doesn't increase startup time.
      missing = true,
      -- try to load one of these colorschemes when starting an installation during startup
      colorscheme = { "everforest", "habamax" },
    },
    git = {
      timeout = 300,
    },
    performance = {
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })

  for k, v in pairs(self) do
    if type(v) ~= 'function' then
      self[k] = nil
    end
  end
end

_G.packadd = function(repo)
  if not pack.repos then
    pack.repos = {}
  end
  table.insert(pack.repos, repo)
end

_G.exec_filetype = function(group)
  group = type(group) == 'string' and { group } or group
  local curbuf = api.nvim_get_current_buf()
  for _, g in ipairs(group) do
    api.nvim_exec_autocmds('FileType', { group = g, pattern = vim.bo[curbuf].filetype })
  end
end

return pack
