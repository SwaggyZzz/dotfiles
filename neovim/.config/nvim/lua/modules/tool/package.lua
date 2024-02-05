packadd({ "nvim-lua/plenary.nvim", lazy = true })
packadd({
  "nvim-tree/nvim-tree.lua",
  lazy = true,
  cmd = {
    "NvimTreeToggle",
    "NvimTreeOpen",
    "NvimTreeFindFile",
    "NvimTreeFindFileToggle",
    "NvimTreeRefresh",
  },
  config = require("tool.config.nvim-tree"),
})
packadd({
  "echasnovski/mini.bufremove",
  version = "*",
  config = function()
    require("mini.bufremove").setup({
      silent = true,
    })
  end,
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
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI" },
  config = require("tool.config.gitsigns")
})
----------------------------------------------------------------------
--                        Telescope Plugins                         --
----------------------------------------------------------------------
packadd({
  "nvim-telescope/telescope.nvim",
  lazy = true,
  cmd = "Telescope",
  config = require("tool.config.telescope"),
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "cljoly/telescope-repo.nvim" },
  }
})
