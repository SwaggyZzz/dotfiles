return function()
  local map = vim.keymap.set
  map('n', 'zR', require('ufo').openAllFolds, { desc = 'Open All Folds' })
  map('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close All Folds' })
  map('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Open Folds Except Kinds' })
  map('n', 'zm', require('ufo').closeFoldsWith, { desc = 'Close Folds With Number' }) -- closeAllFolds == closeFoldsWith(0)

  vim.o.foldcolumn = '0' -- '0' is not bad
  vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  require('ufo').setup {
    provider_selector = function(bufnr, filetype, buftype)
      local lsp_clients = vim.lsp.get_clients {
        bufnr = bufnr,
      }
      if #lsp_clients > 0 then
        return { 'lsp', 'treesitter' }
      end

      return { 'treesitter', 'indent' }
    end,
    close_fold_kinds_for_ft = {
      default = { 'imports' },
      -- default = { "imports", "comment" },
    },
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' 󰁂 %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0

      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end

      table.insert(newVirtText, { suffix, 'MoreMsg' })

      return newVirtText
    end,
  }
end
