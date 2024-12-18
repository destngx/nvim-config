return {
  "olimorris/codecompanion.nvim",
  enabled = DestNgxVim.plugins.ai.copilot.enabled,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  init = function()
    vim.cmd([[cab cc CodeCompanion]])
  end,
  opts = {
    display = {
      chat = {
        show_settings = true,
        render_headers = true,
        show_references = false,
        show_header_separator = true,
      },
      diff = {
        provider = "mini_diff",
      },
    },
    strategies = {
      chat = {
        adapter = "copilot",
        roles = {
          llm = " ", -- The markdown header content for the LLM's responses
          user = " ", -- The markdown header for your questions
        },
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
              n = "<C-c",
              i = "<C-c",
            },
            index = 4,
            callback = "keymaps.stop",
            description = "Stop Request",
          },
        },
      }
    },
  },
}
