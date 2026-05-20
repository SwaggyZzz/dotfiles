return {
  {
    'carlos-algms/agentic.nvim',
    event = 'VeryLazy',
    opts = {
      provider = 'codex-acp',
      windows = {
        position = 'right',
        width = '40%',
      },
      diff_preview = {
        enabled = true,
        layout = 'split',
        center_on_navigate_hunks = true,
      },
    },
    keys = {
      {
        '<leader>ai',
        function()
          require('agentic').toggle()
        end,
        mode = { 'n', 'v', 'i' },
        desc = 'Agentic Toggle Chat',
      },
      {
        '<leader>af',
        function()
          require('agentic').add_selection_or_file_to_context()
        end,
        mode = { 'n', 'v' },
        desc = 'Agentic Add Context',
      },
      {
        '<leader>an',
        function()
          require('agentic').new_session()
        end,
        mode = { 'n', 'v', 'i' },
        desc = 'Agentic New Session',
      },
      {
        '<leader>ar',
        function()
          require('agentic').restore_session()
        end,
        mode = { 'n', 'v', 'i' },
        desc = 'Agentic Restore Session',
      },
      {
        '<leader>aL',
        function()
          require('agentic').rotate_layout()
        end,
        desc = 'Agentic Rotate Layout',
      },
      {
        '<leader>ax',
        function()
          require('agentic').stop_generation()
        end,
        desc = 'Agentic Stop Generation',
      },
      {
        '<leader>aE',
        function()
          require('agentic').add_current_line_diagnostics()
        end,
        desc = 'Agentic Add Line Diagnostic',
      },
      {
        '<leader>aB',
        function()
          require('agentic').add_buffer_diagnostics()
        end,
        desc = 'Agentic Add Buffer Diagnostics',
      },
    },
  },
}
