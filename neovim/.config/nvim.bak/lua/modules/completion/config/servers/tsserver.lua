return function(opts)
  local ok, typescript = pcall(require, "typescript")

  if ok then
    typescript.setup({
      disable_commands = false, -- prevent the plugin from creating Vim commands
      debug = false,            -- enable debug logging for commands
      go_to_source_definition = {
        fallback = true,        -- fall back to standard LSP definition on failure
      },
      server = {
        capabilities = opts.capabilities,
        flags = opts.flags,
        on_attach = function(client, bufnr)
          opts.on_attach(client, bufnr)
          if vim.fn.has("nvim-0.10") then
            -- Enable inlay hints
            vim.lsp.inlay_hint(bufnr, true)
          end
          --[[
                :TypescriptOrganizeImports
                :TypescriptRenameFile
                :TypescriptAddMissingImports
                :TypescriptRemoveUnused
                :TypescriptFixAll
                :TypescriptGoToSourceDefinition
            ]]
        end
      }
    })
  end
end
