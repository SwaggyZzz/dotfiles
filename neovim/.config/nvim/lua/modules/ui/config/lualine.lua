return function()
  -- local icons = {
  --   diagnostics = require("swaggyz.icons").get("diagnostics", true),
  --   git = require("swaggyz.icons").get("git", true),
  --   git_nosep = require("swaggyz.icons").get("git"),
  --   misc = require("swaggyz.icons").get("misc", true),
  --   ui = require("swaggyz.icons").get("ui", true),
  -- }

  local colors = {
    bg = "#202328",
    fg = "#bbc2cf",
    yellow = "#ECBE7B",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#98be65",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    purple = "#c678dd",
    blue = "#51afef",
    red = "#ec5f67",
  }

  local icons = require('swaggyz.new-icons')

  local conditions = {
    has_enough_room = function()
      return vim.o.columns > 100
    end,
    has_comp_before = function()
      return vim.bo.filetype ~= ""
    end,
    has_git = function()
      local gitdir = vim.fs.find(".git", {
        limit = 1,
        upward = true,
        type = "directory",
        path = vim.fn.expand("%:p:h"),
      })
      return #gitdir > 0
    end,
  }

  ---@class lualine_hlgrp
  ---@field fg string
  ---@field bg string
  ---@field gui string?
  local utils = {
    force_centering = function()
      return "%="
    end,
    abbreviate_path = function(path)
      local home = require("swaggyz.global").home
      if path:find(home, 1, true) == 1 then
        path = "~" .. path:sub(#home + 1)
      end
      return path
    end,
  }

  local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed,
      }
    end
  end

  local branch = icons.git.Branch

-- if lvim.colorscheme == "lunar" then
  branch = "%#SLGitIcon#" .. icons.git.Branch .. "%*" .. "%#SLBranchName#"
-- end

  local components = {
    separator = { -- use as section separators
      function()
        return "│"
      end,
      padding = 0,
      -- color = utils.gen_hl("surface1", true, true),
    },

    file_status = {
      function()
        local function is_new_file()
          local filename = vim.fn.expand("%")
          return filename ~= "" and vim.bo.buftype == "" and vim.fn.filereadable(filename) == 0
        end

        local symbols = {}
        if vim.bo.modified then
          table.insert(symbols, "[+]")
        end
        if vim.bo.modifiable == false then
          table.insert(symbols, "[-]")
        end
        if vim.bo.readonly == true then
          table.insert(symbols, "[RO]")
        end
        if is_new_file() then
          table.insert(symbols, "[New]")
        end
        return #symbols > 0 and table.concat(symbols, "") or ""
      end,
      padding = { left = -1, right = 1 },
      cond = conditions.has_comp_before,
    },

    -- lsp = {
    --   function()
    --     local buf_ft = vim.api.nvim_get_option_value("filetype", { scope = "local" })
    --     local clients = vim.lsp.get_active_clients()
    --     local lsp_lists = {}
    --     local available_servers = {}
    --     if next(clients) == nil then
    --       return icons.misc.NoActiveLsp -- No server available
    --     end
    --     for _, client in ipairs(clients) do
    --       local filetypes = client.config.filetypes
    --       local client_name = client.name
    --       if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
    --         -- Avoid adding servers that already exists.
    --         if not lsp_lists[client_name] then
    --           lsp_lists[client_name] = true
    --           table.insert(available_servers, client_name)
    --         end
    --       end
    --     end
    --     return next(available_servers) == nil and icons.misc.NoActiveLsp
    --         or string.format("%s[%s]", icons.misc.LspAvailable, table.concat(available_servers, ", "))
    --   end,
    --   cond = conditions.has_enough_room,
    -- },

    cwd = {
      function()
        return icons.ui.FolderWithHeart .. utils.abbreviate_path(vim.fs.normalize(vim.fn.getcwd()))
      end,
      -- color = utils.gen_hl("subtext0", true, true, nil, "bold"),
    },

    file_location = {
      function()
        local cursorline = vim.fn.line(".")
        local cursorcol = vim.fn.virtcol(".")
        local filelines = vim.fn.line("$")
        local position
        if cursorline == 1 then
          position = "Top"
        elseif cursorline == filelines then
          position = "Bot"
        else
          position = string.format("%2d%%%%", math.floor(cursorline / filelines * 100))
        end
        return string.format("%s · %3d:%-2d", position, cursorline, cursorcol)
      end,
    },

    -- =========================== new ============
    mode = {
      function()
        return " " .. icons.ui.Target .. " "
      end,
      padding = { left = 0, right = 0 },
      color = {},
      cond = nil,
    },
    branch = {
      "b:gitsigns_head",
      icon = branch,
      color = { gui = "bold" },
    },
    filename = {
      "filename",
      color = {},
      cond = nil,
    },
    diff = {
      "diff",
      source = diff_source,
      symbols = {
        added = icons.git.LineAdded .. " ",
        modified = icons.git.LineModified .. " ",
        removed = icons.git.LineRemoved .. " ",
      },
      padding = { left = 2, right = 1 },
      diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.yellow },
        removed = { fg = colors.red },
      },
      cond = nil,
    },
    diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = {
        error = icons.diagnostics.BoldError .. " ",
        warn = icons.diagnostics.BoldWarning .. " ",
        info = icons.diagnostics.BoldInformation .. " ",
        hint = icons.diagnostics.BoldHint .. " ",
      },
      -- cond = conditions.hide_in_width,
    },
    treesitter = {
      function()
        return icons.ui.Tree
      end,
      color = function()
        local buf = vim.api.nvim_get_current_buf()
        local ts = vim.treesitter.highlighter.active[buf]
        return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
      end,
      cond = conditions.has_enough_room,
    },
    lsp = {
      function()
        local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
        if #buf_clients == 0 then
          return "LSP Inactive"
        end
  
        local buf_ft = vim.bo.filetype
        local buf_client_names = {}
        local copilot_active = false
  
        -- add client
        for _, client in pairs(buf_clients) do
          if client.name ~= "null-ls" and client.name ~= "copilot" then
            table.insert(buf_client_names, client.name)
          end
  
          if client.name == "copilot" then
            copilot_active = true
          end
        end
  
        -- -- add formatter
        -- local formatters = require "lvim.lsp.null-ls.formatters"
        -- local supported_formatters = formatters.list_registered(buf_ft)
        -- vim.list_extend(buf_client_names, supported_formatters)
  
        -- -- add linter
        -- local linters = require "lvim.lsp.null-ls.linters"
        -- local supported_linters = linters.list_registered(buf_ft)
        -- vim.list_extend(buf_client_names, supported_linters)
  
        local unique_client_names = table.concat(buf_client_names, ", ")
        local language_servers = string.format("[%s]", unique_client_names)
  
        if copilot_active then
          language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
        end
  
        return language_servers
      end,
      color = { gui = "bold" },
      cond = conditions.hide_in_width,
    },
    location = { "location" },
    progress = {
      "progress",
      fmt = function()
        return "%P/%L"
      end,
      color = {},
    },
  
    spaces = {
      function()
        local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
        return icons.ui.Tab .. " " .. shiftwidth
      end,
      padding = 1,
    },
    encoding = {
      "o:encoding",
      fmt = string.upper,
      color = {},
      cond = conditions.hide_in_width,
    },
    filetype = { "filetype", cond = nil, padding = { left = 1, right = 1 } },
    scrollbar = {
      function()
        local current_line = vim.fn.line "."
        local total_lines = vim.fn.line "$"
        local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
        local line_ratio = current_line / total_lines
        local index = math.ceil(line_ratio * #chars)
        return chars[index]
      end,
      padding = { left = 0, right = 0 },
      color = "SLProgress",
      cond = nil,
    },
  }

  local function is_active()
    local ok, hydra = pcall(require, 'hydra.statusline')
    return ok and hydra.is_active()
  end

  local function get_name()
    local ok, hydra = pcall(require, 'hydra.statusline')
    if ok then
      return hydra.get_name()
    end
    return ''
  end

  -- require("lualine").setup({
  --   options = {
  --     icons_enabled = true,
  --     disabled_filetypes = {
  --       statusline = { "alpha" }
  --       -- statusline = { "alpha", "NvimTree", "Outline" }
  --     },
  --     globalstatus = true,
  --     component_separators = "",
  --     section_separators = { left = "", right = "" },
  --   },
  --   sections = {
  --     lualine_a = { "mode" },
  --     lualine_b = {
  --       {
  --         "filetype",
  --         colored = true,
  --         icon_only = false,
  --         icon = { align = "left" },
  --       },
  --       components.file_status,
  --       { get_name, cond = is_active },
  --     },
  --     lualine_c = {
  --       {
  --         "branch",
  --         icon = icons.git_nosep.Branch,
  --         cond = conditions.has_git,
  --       },
  --       {
  --         "diff",
  --         symbols = {
  --           added = icons.git.Add,
  --           modified = icons.git.Mod_alt,
  --           removed = icons.git.Remove,
  --         },
  --         source = diff_source,
  --         colored = false,
  --         cond = conditions.has_git,
  --         padding = { right = 1 },
  --       },

  --       { utils.force_centering },
  --       {
  --         "diagnostics",
  --         sources = { "nvim_diagnostic" },
  --         sections = { "error", "warn", "info", "hint" },
  --         symbols = {
  --           error = icons.diagnostics.Error,
  --           warn = icons.diagnostics.Warning,
  --           info = icons.diagnostics.Information,
  --           hint = icons.diagnostics.Hint_alt,
  --         },
  --       },
  --       components.lsp,
  --     },
  --     lualine_x = {
  --       -- {
  --       --   "encoding",
  --       --   fmt = string.upper,
  --       --   padding = { left = 1 },
  --       --   cond = conditions.has_enough_room,
  --       -- },
  --       -- {
  --       --   "fileformat",
  --       --   symbols = {
  --       --     unix = "LF",
  --       --     dos = "CRLF",
  --       --     mac = "CR", -- Legacy macOS
  --       --   },
  --       --   padding = { left = 1 },
  --       -- },
  --       components.tabwidth,
  --     },
  --     lualine_y = {
  --       components.cwd,
  --     },
  --     lualine_z = { components.file_location },
  --   },
  --   inactive_sections = {
  --     lualine_a = {},
  --     lualine_b = {},
  --     lualine_c = { "filename" },
  --     lualine_x = { "location" },
  --     lualine_y = {},
  --     lualine_z = {},
  --   },
  --   tabline = {},
  --   extensions = {
  --     "quickfix",
  --     "nvim-tree",
  --     "nvim-dap-ui",
  --     "toggleterm",
  --     "fugitive",
  --     outline,
  --     diffview,
  --   },
  -- })

  require("lualine").setup({
    options = {
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    -- component_separators = "",
    -- section_separators = { left = "", right = "" },
      icons_enabled = true,
      globalstatus = true,
      disabled_filetypes = { "alpha" },
    },
    sections = {
      lualine_a = { 
        components.mode,
      },
      lualine_b = {
        components.branch,
        components.diagnostics,
      },
      lualine_c = {
        components.diff,
      },
      lualine_x = {
        components.lsp,
        components.spaces,
        components.filetype,
      },
      lualine_y = { components.location },
      lualine_z = {
        components.progress,
      },
    },
    inactive_sections = {
      lualine_a = {
        components.mode,
      },
      lualine_b = {
        components.branch,
      },
      lualine_c = {
        components.diff,
      },
      lualine_x = {
        components.diagnostics,
        components.lsp,
        components.spaces,
        components.filetype,
      },
      lualine_y = { components.location },
      lualine_z = {
        components.progress,
      },
    },
    tabline = {},
    extensions = {
      -- "quickfix",
      -- "nvim-tree",
      -- "nvim-dap-ui",
      -- "toggleterm",
      -- "fugitive",
    },
  })
end
