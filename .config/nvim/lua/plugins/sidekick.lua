return {
  {
    'folke/sidekick.nvim',
    event = 'VeryLazy',
    opts = {
      nes = { enabled = false },
      cli = {
        tools = {
          coco = {
            cmd = { 'coco' },
            title = 'Coco AI',
          },
        },
      },
    },
    keys = {
      -- === 核心交互 ===
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle()
        end,
        desc = 'Sidekick Toggle CLI',
      },

      -- === 其他工具 ===
      {
        '<leader>as',
        function()
          require('sidekick.cli').select()
        end,
        desc = 'Select Sidekick CLI',
      },
      {
        '<leader>ad',
        function()
          require('sidekick.cli').close()
        end,
        desc = 'Detach CLI Session',
      },

      -- === 上下文发送 ===
      {
        '<leader>at',
        function()
          require('sidekick.cli').send { msg = '{this}' }
        end,
        mode = {
          'x',
          'n',
        },
        desc = 'Send {this}',
      },
      {
        '<leader>af',
        function()
          require('sidekick.cli').send { msg = '{file}' }
        end,
        desc = 'Send {file}',
      },
      {
        '<leader>av',
        function()
          require('sidekick.cli').send { msg = '{selection}' }
        end,
        mode = { 'x' },
        desc = 'Send Selection',
      },
      {
        '<leader>ap',
        function()
          require('sidekick.cli').prompt()
        end,
        mode = { 'n', 'x' },
        desc = 'Select Prompt',
      },
    },
  },

  -- 允许在 Picker (搜索窗口) 中直接把选中的文件投喂给 Sidekick
  {
    'folke/snacks.nvim',
    opts = {
      picker = {
        actions = {
          -- 定义一个名为 sidekick_send 的动作
          sidekick_send = function(...)
            return require('sidekick.cli.picker.snacks').send(...)
          end,
        },
        win = {
          input = {
            keys = {
              -- 绑定 <Alt-a> 触发发送动作
              ['<A-a>'] = {
                'sidekick_send',
                mode = { 'n', 'i' },
                desc = 'Send to Sidekick',
              },
            },
          },
        },
      },
    },
  },
}
