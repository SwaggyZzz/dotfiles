-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
    -- local copy_to_unnamedplus = require('vim.ui.clipboard.osc52').copy '+'
    -- copy_to_unnamedplus(vim.v.event.regcontents)
    -- local copy_to_unnamed = require('vim.ui.clipboard.osc52').copy '*'
    -- copy_to_unnamed(vim.v.event.regcontents)
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = vim.api.nvim_create_augroup('ResizeSplits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('LastLoc', { clear = true }),
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = vim.api.nvim_create_augroup('AutoCreateDir', { clear = true }),
  callback = function(event)
    if event.match:match '^%w%w+:[\\/][\\/]' then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- 禁用大文件部分的插件功能以提升性能
vim.api.nvim_create_autocmd({ 'BufReadPre' }, {
  group = vim.api.nvim_create_augroup('BigFileDisable', { clear = true }),
  callback = function(ev)
    local max_filesize = vim.g.bigfile_size or (1024 * 1024 * 1.5)
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
    if ok and stats and stats.size > max_filesize then
      vim.b[ev.buf].large_file = true
      vim.schedule(function()
        pcall(vim.api.nvim_command, 'syntax clear')
      end)
      vim.opt_local.foldmethod = 'manual'
      vim.opt_local.spell = false
      -- Disable LSP for large files
      vim.schedule(function()
        pcall(vim.api.nvim_command, 'LspStop')
      end)
    end
  end,
})

-- 修复 LSP 返回不支持格式时的崩溃问题 (如 tsgo/vtsls 在跳转 less 模块时返回绝对路径而不是 file:// 协议的 URI)
-- Neovim 0.12 版本对 vim.uri 的检查变得严格，缺少 scheme 会抛出 "URI must contain a scheme" 异常
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('FixLspUri', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    -- 拦截并劫持原有的 client.request 方法
    local orig_request = client.request
    client.request = function(self, method, params, handler, req_bufnr)
      -- 我们只关心那些会返回代码位置信息 (Location / LocationLink) 的请求
      local methods = {
        ['textDocument/definition'] = true,
        ['textDocument/typeDefinition'] = true,
        ['textDocument/declaration'] = true,
        ['textDocument/implementation'] = true,
        ['textDocument/references'] = true,
      }

      if methods[method] and type(handler) == 'function' then
        -- 包装原始的 callback 处理函数
        local function wrapped_handler(err, result, ctx, config)
          if not err and result and type(result) == 'table' then
            -- 如果结果是数组形式（多个跳转目标）
            if result[1] ~= nil then
              for _, item in ipairs(result) do
                if type(item) == 'table' then
                  -- 检查 uri 字段是否存在且是否缺失 scheme 头 (例如 "file://")
                  if item.uri and not string.match(item.uri, '^%a+://') then
                    item.uri = 'file://' .. item.uri
                  end
                  -- LocationLink 返回格式使用 targetUri 字段
                  if item.targetUri and not string.match(item.targetUri, '^%a+://') then
                    item.targetUri = 'file://' .. item.targetUri
                  end
                end
              end
            else
              -- 如果结果是单个对象形式（单个跳转目标）
              if result.uri and not string.match(result.uri, '^%a+://') then
                result.uri = 'file://' .. result.uri
              end
              if result.targetUri and not string.match(result.targetUri, '^%a+://') then
                result.targetUri = 'file://' .. result.targetUri
              end
            end
          end
          -- 将处理过的 result 传递给真实的处理函数
          return handler(err, result, ctx, config)
        end
        return orig_request(self, method, params, wrapped_handler, req_bufnr)
      end
      return orig_request(self, method, params, handler, req_bufnr)
    end
  end,
})
