local M = {}

-- Gets all lsp clients that support formatting
-- and have not disabled it in their client config
function M.supports_format(client)
  if
      client.config
      and client.config.capabilities
      and client.config.capabilities.documentFormattingProvider == false
  then
    return false
  end
  return client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")
end

-- Gets all lsp clients that support formatting.
-- When a null-ls formatter is available for the current filetype,
-- only null-ls formatters are returned.
function M.get_formatters(bufnr)
  local ft = vim.bo[bufnr].filetype
  -- check if we have any null-ls formatters for the current filetype
  local null_ls = package.loaded["null-ls"] and require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") or {}

  local ret = {
    active = {},       -- 支持format的lsp
    available = {},    -- 不支持format的lsp
    null_ls = null_ls, -- null-ls formatters
  }

  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

  for _, client in ipairs(clients) do
    if #null_ls == 0 and client.name == 'eslint' then
      table.insert(ret.active, client)
    end

    if M.supports_format(client) then
      if (#null_ls > 0 and client.name == "null-ls") or #null_ls == 0 then
        table.insert(ret.active, client)
      else
        table.insert(ret.available, client)
      end
    end
  end

  return ret
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()

  local formatters = M.get_formatters(buf)
  local client_ids = vim.tbl_map(function(client)
    return client.id
  end, formatters.active)

  if #client_ids == 0 then
    return
  end

  local client_names = vim.tbl_map(function(client)
    return client.name
  end, formatters.active)

  if vim.tbl_contains(client_names, 'eslint') then
    vim.api.nvim_command('EslintFixAll')
  else
    vim.lsp.buf.format({
      bufnr = buf,
      filter = function(client)
        return vim.tbl_contains(client_ids, client.id)
      end,
      -- async boolean|nil If true the method won't block. Defaults to false.
      -- Editing the buffer while formatting asynchronous can lead to unexpected changes.
      async = false
    })
  end
end

function M.setup()
  vim.api.nvim_create_user_command('CodeFormat', function()
    M.format()
  end, { nargs = 0 })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("format_on_save", {}),
    callback = function()
      M.format()
    end,
  })
end

return M
