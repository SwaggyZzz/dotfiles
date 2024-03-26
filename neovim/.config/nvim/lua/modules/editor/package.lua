packadd({
  "max397574/better-escape.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI" },
  config = require("editor.config.better-escape"),
})

packadd({
  "nvimdev/hlsearch.nvim",
  lazy = true,
  event = "BufRead",
  config = function()
    require('hlsearch').setup()
  end
})

packadd({
  "echasnovski/mini.pairs",
  event = "VeryLazy",
  opts = {},
})

packadd({
  "echasnovski/mini.ai",
  event = "VeryLazy",
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }, {}),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
      },
    }
  end,
  config = function(_, opts)
    require("mini.ai").setup(opts)
  end,
})

packadd({
  "echasnovski/mini.comment",
  event = "VeryLazy",
  opts = {
    options = {
      ignore_blank_line = true,
      custom_commentstring = function()
        return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
      end,
    },
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Toggle comment (like `gcip` - comment inner paragraph) for both
      -- Normal and Visual modes
      comment = 'gc',

      -- Toggle comment on current line
      comment_line = '<A-/>',

      -- Toggle comment on visual selection
      comment_visual = '<A-/>',

      -- Define 'comment' textobject (like `dgc` - delete whole comment block)
      textobject = 'gc',
    },
  },
})

packadd({
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = true,
  keys = {
    -- { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    -- { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    -- { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    -- { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
  },
})

packadd({
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  opts = { use_diagnostic_signs = true },
})

packadd({
  "folke/flash.nvim",
  event = { "CursorHold", "CursorHoldI" },
  ---@type Flash.Config
  opts = {},
  keys = {
    {
      "<leader>w",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "<leader>W",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
})

packadd({
  "kevinhwang91/nvim-ufo",
  lazy = true,
  dependencies = "kevinhwang91/promise-async",
  init = function()
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    vim.o.foldcolumn = "0" -- '0' is not bad
    vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
})

-- packadd({
--   "luukvbaal/statuscol.nvim",
--   event = "VeryLazy",
--   config = require("editor.config.statuscol"),
-- })

packadd({
  "sindrets/diffview.nvim",
  lazy = true,
  event = "BufRead",
  cmd = { "DiffviewOpen", "DiffviewClose" },
})

packadd({
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  opts = {
    delay = 200,
    large_file_cutoff = 2000,
    large_file_overrides = {
      providers = { "lsp" },
    },
  },
  config = function(_, opts)
    require("illuminate").configure(opts)

    local function map(key, dir, buffer)
      vim.keymap.set("n", key, function()
        require("illuminate")["goto_" .. dir .. "_reference"](false)
      end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
    end

    map("]]", "next")
    map("[[", "prev")

    -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        local buffer = vim.api.nvim_get_current_buf()
        map("]]", "next", buffer)
        map("[[", "prev", buffer)
      end,
    })
  end,
  keys = {
    { "]]", desc = "Next Reference" },
    { "[[", desc = "Prev Reference" },
  },
})

packadd({
  "simrat39/symbols-outline.nvim",
  keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
  cmd = "SymbolsOutline",
  config = require("editor.config.symbols-outline"),
})

packadd({
  "nvim-pack/nvim-spectre",
  build = false,
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
})


----------------------------------------------------------------------
--                  :treesitter related plugins                    --
----------------------------------------------------------------------
packadd({
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  cmd = {
    "TSInstall",
    "TSUninstall",
    "TSUpdate",
    "TSUpdateSync",
    "TSInstallInfo",
    "TSInstallSync",
    "TSInstallFromGrammar",
  },
  event = "BufReadPre",
  config = require("editor.config.treesitter"),
  dependencies = {
    -- { "andymass/vim-matchup" },
    -- {
    --   "hiphish/rainbow-delimiters.nvim",
    --   config = require("editor.config.rainbow"),
    -- },
    {
      "NvChad/nvim-colorizer.lua",
      config = require("editor.config.colorizer"),
    },
  },
})
packadd({
  "JoosepAlviste/nvim-ts-context-commentstring",
  lazy = true,
})
packadd({
  "windwp/nvim-ts-autotag",
  config = function()
    require('nvim-ts-autotag').setup()
  end,
})
