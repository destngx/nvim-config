return {
  "ibhagwan/fzf-lua",
  lazy = false,
  branch = "main",
  opts = function(_, opts)
    local actions = require("fzf-lua.actions")
    local window_picker = require("utils.window_picker")

    -- Custom action that uses Snacks window picker
    local function file_edit_with_picker(selected, opts_inner)
      if not selected or #selected == 0 then
        return
      end

      local entry = require("fzf-lua.path").entry_to_file(selected[1], opts_inner)
      ---@diagnostic disable-next-line: undefined-field
      local file_path = entry.path or entry.file

      if not file_path then
        return
      end

      window_picker.open_file_smart(file_path, "edit")
    end

    local img_previewer ---@type string[]?
    for _, v in ipairs({
      { cmd = "ueberzug", args = {} },
      { cmd = "chafa", args = {
        "{file}",
        -- "--colors=full",
        -- "--color-space=din99d",
        -- "--dither=bayer",
        -- "--dither-grain=1",
        -- "--dither-intensity=0.5",
        -- "--fill=braille"
      } },
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
          snacks_image = { enabled = false }, -- disable snacks image previewer for binary like pdf since it causes lags
          -- ueberzug_scaler = "fit_contain",
        },
      },
      winopts = {
        height = 0.6,
        width = 0.6,
        row = 0.6,
        border = "none",
        preview = {
          layout = "flex",
          scrollchars = { "┃", "" },
          delay = 300,
        },
        backdrop = 60,
      },
      hls = { normal = "Pmenu" },
      fzf_opts = {
        ["--no-info"] = "",
        ["--info"] = "hidden",
        ["--padding"] = "4%,4%,4%,4%",     -- Reduce padding for ui_select
        ["--header"] = " ",
        ["--no-scrollbar"] = "",
      },
      ui_select = function(fzf_opts, items)
        return vim.tbl_deep_extend("force", fzf_opts, {
          prompt = " ",
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
        actions = {
          ["default"] = file_edit_with_picker,
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
        no_header = false,
        cwd_header = true,
        cwd_prompt = false,
        winopts = {
          row = 1,
          width = vim.api.nvim_win_get_width(0),
          height = 0.5,
          preview = {
            hidden = false,
          },
        },
        actions = {
          ["default"] = file_edit_with_picker,
          ["alt-i"] = { actions.toggle_ignore },
          ["alt-h"] = { actions.toggle_hidden },
        },
      },
      files = {
        multiprocess = true,
        formatter = "path.filename_first",
        git_icons = true,
        prompt = DestNgxVim.icons.telescope,
        winopts = {
          preview = {
            hidden = false,
          },
        },
        no_header = false,
        cwd_header = true,
        actions = {
          ["default"] = file_edit_with_picker,
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
        winopts = {
          preview = {
            hidden = false,
          },
        },
        no_header = true,
        fzf_opts = { ["--delimiter"] = " ", ["--with-nth"] = "-1.." },
        actions = {
          ["default"] = file_edit_with_picker,
        },
      },
      helptags = {
        prompt = "💡: ",
        winopts = {
          row = 1,
          width = vim.api.nvim_win_get_width(0),
          height = 0.3,
          preview = {
            hidden = false,
          },
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
          winopts = {
            preview = {
              hidden = false,
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
            width = 0.6,
            height = 0.5,
            preview = {
              layout = "horizontal",
              horizontal = "up:75%",
            },
          },
        },
      },
      registers = {
        prompt = "Registers: ",
        winopts = {
          width = 0.8,
          height = 0.7,
          preview = {
            hidden = true,
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
    local config = require("fzf-lua.config")

    -- Setup fzf-lua with ui_select configuration
    fzf_lua.setup(options)

    -- Configure keymaps after setup
    config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
    config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
    config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
    config.defaults.keymap.fzf["ctrl-x"] = "jump"

    -- Explicitly register ui_select to ensure it's set
    -- This ensures fzf-lua handles vim.ui.select (for code actions, etc.)
    vim.schedule(function()
      fzf_lua.register_ui_select()
    end)
  end,
}
