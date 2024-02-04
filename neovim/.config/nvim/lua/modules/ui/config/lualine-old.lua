return function()
  local icons = {
    -- diagnostics = require("swaggyz.icons").get("diagnostics"),
    git = require("swaggyz.icons").get("git")
  }

  local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end

  require("lualine").setup({
    options = {
      -- component_separators = { left = "", right = "" },
      -- -- https://github.com/ryanoasis/powerline-extra-symbols
      -- -- section_separators = { left = " ", right = "" },
      -- section_separators = { left = "", right = "" },
      theme = "auto",
      globalstatus = true,
      disabled_filetypes = {
        statusline = { "alpha" }
        -- statusline = { "alpha", "NvimTree", "Outline" }
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        {
          "diagnostics",
          -- symbols = {
          --   error = icons.diagnostics.Error,
          --   warn = icons.diagnostics.Warn,
          --   info = icons.diagnostics.Info,
          --   hint = icons.diagnostics.Hint,
          -- },
        },
        -- stylua: ignore
        {
          function() return require("nvim-navic").get_location() end,
          cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
        },
      },
      lualine_x = {
        {
          "diff",
          symbols = {
            added = icons.git.added,
            modified = icons.git.modified,
            removed = icons.git.removed,
          },
          cond = hide_in_width,
        },
        {
          "filetype",
          icon_only = true,
          separator = "",
          padding = { left = 1, right = 0 }
        },
        { "filename", path = 4, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        "filesize"
      },
      lualine_y = {
        { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        function()
          return " " .. os.date("%R")
        end,
      },
    },
    extensions = {
      "neo-tree",
      "lazy",
      "aerial",
      "fugitive",
      "fzf",
      "nvim-dap-ui",
      "nvim-tree",
      "quickfix",
      "symbols-outline",
      "toggleterm",
      "trouble ",
    }
  })
end
