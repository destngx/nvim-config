return {
  "ibhagwan/fzf-lua",
  event = "VimEnter",
  branch = "main",
  opts = function(_, opts)
    local actions = require("fzf-lua.actions")
    local config = require("fzf-lua.config")

    -- Quickfix
    config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
    config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
    config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
    config.defaults.keymap.fzf["ctrl-x"] = "jump"
    config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
    config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"

    local img_previewer ---@type string[]?
    for _, v in ipairs({
      { cmd = "ueberzug", args = {} },
      { cmd = "chafa",    args = { "{file}", "--format=symbols" } },
      { cmd = "viu",      args = { "-b" } },
    }) do
      if vim.fn.executable(v.cmd) == 1 then
        img_previewer = vim.list_extend({ v.cmd }, v.args)
        break
      end
    end
    return {
      previewers = {
        builtin = {
          extensions = {
            ["png"] = img_previewer,
            ["jpg"] = img_previewer,
            ["jpeg"] = img_previewer,
            ["gif"] = img_previewer,
            ["webp"] = img_previewer,
          },
          ueberzug_scaler = "fit_contain",
        },
      },
      winopts = {
        height = 0.6,
        width = 0.6,
        row = 0.6,
        hl = { normal = "Pmenu" },
        border = "none",
        preview = {
          layout = "flex",
          scrollchars = { "┃", "" },
        },
        backdrop = 60,
      },
      fzf_opts = {
        ["--no-info"] = "",
        ["--info"] = "hidden",
        ["--padding"] = "13%,5%,13%,5%",
        ["--header"] = " ",
        ["--no-scrollbar"] = "",
      },
      ui_select = function(fzf_opts, items)
        return vim.tbl_deep_extend("force", fzf_opts, {
          prompt = " ",
          winopts = {
            title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
            title_pos = "center",
          },
        }, fzf_opts.kind == "codeaction" and {
          winopts = {
            layout = "vertical",
            -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
            height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
            width = 0.5,
            preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
              layout = "vertical",
              vertical = "down:15,border-top",
              hidden = "hidden",
            } or {
              layout = "vertical",
              vertical = "down:15,border-top",
            },
          },
        } or {
          winopts = {
            width = 0.5,
            -- height is number of items, with a max of 80% screen height
            height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
          },
        })
      end,
      oldfiles = {
        formatter = "path.filename_first",
        git_icons = true,
        preview_opts = "hidden",
        actions = {
          ["alt-i"] = { actions.toggle_ignore },
          ["alt-h"] = { actions.toggle_hidden },
        },
      },
      live_grep = {
        multiprocess = true,
        formatter = "path.filename_first",
        git_icons = true,
        prompt = "grep: ",
        cmd = "rg --vimgrep --no-heading --smart-case --hidden --follow --color=always --line-number {q} || true",
        preview_opts = "nohidden",
        no_header = false,
        cwd_header = true,
        cwd_prompt = false,
        winopts = {
          row = 1,
          width = vim.api.nvim_win_get_width(0),
          height = 0.5,
        },
        actions = {
          ["alt-i"] = { actions.toggle_ignore },
          ["alt-h"] = { actions.toggle_hidden },
        },
      },
      files = {
        multiprocess = true,
        formatter = "path.filename_first",
        git_icons = true,
        prompt = DestNgxVim.icons.telescope,
        preview_opts = "nohidden",
        no_header = false,
        cwd_header = true,
        actions = {
          ["alt-i"] = { actions.toggle_ignore },
          ["alt-h"] = { actions.toggle_hidden },
        },
        cwd_prompt = false,
        --    cwd = function()
        --     local git_path = vim.fn.finddir(".git", ".;")
        --     return vim.fn.fnamemodify(git_path, ":h")
        --    end,
        -- actions = {
        -- check diff selected file with current file
        --   ["ctrl-d"] = function(...)
        --     fzf.actions.file_vsplit(...)
        --     vim.cmd("windo diffthis")
        --     local switch = vim.api.nvim_replace_termcodes("<C-w>h", true, false, true)
        --     vim.api.nvim_feedkeys(switch, "t", false)
        --   end,
        -- },
      },
      buffers = {
        formatter = "path.filename_first",
        prompt = "buffers: ",
        preview_opts = "hidden",
        no_header = true,
        fzf_opts = { ["--delimiter"] = " ", ["--with-nth"] = "-1.." },
      },
      helptags = {
        prompt = "💡: ",
        preview_opts = "hidden",
        winopts = {
          row = 1,
          width = vim.api.nvim_win_get_width(0),
          height = 0.3,
        },
      },
      git = {
        bcommits = {
          prompt = "logs: ",
          cmd = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen%><(12)%cr%><|(12)%Creset %s' <file>",
          preview =
          "git show --stat --color --format='%C(cyan)%an%C(reset)%C(bold yellow)%d%C(reset): %s' {1} -- <file>",
          actions = {
            ["ctrl-d"] = function(...)
              actions.git_buf_vsplit(...)
              vim.cmd("windo diffthis")
              local switch = vim.api.nvim_replace_termcodes("<C-w>h", true, false, true)
              vim.api.nvim_feedkeys(switch, "t", false)
            end,
          },
          preview_opts = "nohidden",
          winopts = {
            preview = {
              layout = "vertical",
              vertical = "right:50%",
              wrap = "wrap",
            },
            row = 1,
            width = vim.api.nvim_win_get_width(0),
            height = 0.5,
          },
        },
        branches = {
          prompt = "branches: ",
          cmd = "git branch --all --color",
          winopts = {
            preview = {
              layout = "vertical",
              vertical = "right:50%",
              wrap = "wrap",
            },
            row = 1,
            width = vim.api.nvim_win_get_width(0),
            height = 0.3,
          },
        },
      },
      -- autocmds = {
      --   prompt = "autocommands:",
      --   winopts = {
      --     width = 0.8,
      --     height = 0.7,
      --     preview = {
      --       layout = "horizontal",
      --       horizontal = "down:40%",
      --       wrap = "wrap",
      --     },
      --   },
      -- },
      keymaps = {
        prompt = "keymaps:",
        winopts = {
          width = 0.8,
          height = 0.7,
        },
        actions = {
          ["default"] = function(selected)
            local lines = vim.split(selected[1], "│", {})
            local mode, key = lines[1]:gsub("%s+", ""), lines[2]:gsub("%s+", "")
            vim.cmd("verbose " .. mode .. "map " .. key)
          end,
        },
      },
      highlights = {
        prompt = "highlights:",
        winopts = {
          width = 0.8,
          height = 0.7,
          preview = {
            layout = "horizontal",
            horizontal = "down:40%",
            wrap = "wrap",
          },
        },
        actions = {
          ["default"] = function(selected)
            print(vim.cmd.highlight(selected[1]))
          end,
        },
      },
      lsp = {
        code_actions = {
          previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
          prompt = "Code Actions: ",
          winopts = {
            width = 0.8,
            height = 0.7,
            preview = {
              layout = "horizontal",
              horizontal = "up:75%",
            },
          },
        },
      },
      registers = {
        prompt = "Registers: ",
        preview_opts = "hidden",
        winopts = {
          width = 0.8,
          height = 0.7,
          preview = {
            layout = "horizontal",
            horizontal = "down:45%",
          },
        },
      },
      keymap = {
        builtin = {
          ["<C-j>"] = "preview-page-down",
          ["<C-k>"] = "preview-page-up",
        },
      }
    }
  end,
  config = function(_, options)
    local fzf_lua = require("fzf-lua")

    fzf_lua.setup(options)

    fzf_lua.register_ui_select(function(_, items)
      local min_h, max_h = 0.60, 0.80
      local h = (#items + 4) / vim.o.lines
      if h < min_h then
        h = min_h
      elseif h > max_h then
        h = max_h
      end
      return { winopts = { height = h, width = 0.80, row = 0.40 } }
    end)
  end,

}
