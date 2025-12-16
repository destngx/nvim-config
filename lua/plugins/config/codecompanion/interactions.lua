return {
  chat = {
    adapter = "copilot",
    keymaps = {
      send = {
        modes = {
          i = { "<C-CR>", "<C-s>" },
        },
      },
      close = {
        modes = {
          n = "q",
        },
        index = 3,
        callback = "keymaps.close",
        description = "Close Chat",
      },
      stop = {
        modes = {
          n = "<C-c>",
          i = "<C-c>",
        },
        index = 4,
        callback = "keymaps.stop",
        description = "Stop Request",
      },
      clear = {
        modes = {
          n = "gX",
        },
        index = 6,
        callback = "keymaps.clear",
        description = "Clear Chat",
      },
    },
    slash_commands = {
      ["help"] = {
        opts = {
          provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
        },
      },
      ["symbols"] = {
        opts = {
          provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
        },
      },
      ["buffer"] = {
        opts = {
          contains_code = true,
          provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
          has_params = true,
        },
      },
      ["file"] = {
        opts = {
          contains_code = true,
          max_lines = 1000,
          provider = "fzf_lua", -- telescope|mini_pick|fzf_lua
        },
      },
    },
    variables = {
      ["buffer"] = {
        opts = {
          default_params = "diff",
        },
      },
    },
    tools = {
      ["next_edit_suggestion"] = {
        opts = {
          ---@type string|fun(path: string):integer?
          jump_action = "tabnew",
        },
      },
    },
  },
  inline = {
    adapter = "copilot",
  },
}
