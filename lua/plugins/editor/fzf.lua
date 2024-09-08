return {
  "ibhagwan/fzf-lua",
  event = "VimEnter",
  branch = "main",
  opts = {
    winopts = {
      height = 0.6,
      width = 0.6,
      row = 0.6,
      hl = { normal = "Pmenu" },
      border = "none",
    },
    fzf_opts = {
      ["--no-info"] = "",
      ["--info"] = "hidden",
      ["--padding"] = "13%,5%,13%,5%",
      ["--header"] = " ",
      ["--no-scrollbar"] = "",
    },
    oldfiles = {
      formatter = "path.filename_first",
      git_icons = true,
      preview_opts = "hidden",
    },
    live_grep = {
      formatter = "path.filename_first",
      git_icons = true,
      prompt = "grep:",
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
    },
    files = {
      formatter = "path.filename_first",
      git_icons = true,
      prompt = DestNgxVim.icons.telescope,
      preview_opts = "hidden",
      no_header = false,
      cwd_header = true,
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
      prompt = "buffers:",
      preview_opts = "hidden",
      no_header = true,
      fzf_opts = { ["--delimiter"] = " ", ["--with-nth"] = "-1.." },
    },
    helptags = {
      prompt = "💡:",
      preview_opts = "hidden",
      winopts = {
        row = 1,
        width = vim.api.nvim_win_get_width(0),
        height = 0.3,
      },
    },
    git = {
      bcommits = {
        prompt = "logs:",
        cmd = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen%><(12)%cr%><|(12)%Creset %s' <file>",
        preview = "git show --stat --color --format='%C(cyan)%an%C(reset)%C(bold yellow)%d%C(reset): %s' {1} -- <file>",
        actions = {
          ["ctrl-d"] = function(...)
            require("fzf-lua").actions.git_buf_vsplit(...)
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
        prompt = "branches:",
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
        prompt = "code actions:",
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
      prompt = "registers:",
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
  },
}
