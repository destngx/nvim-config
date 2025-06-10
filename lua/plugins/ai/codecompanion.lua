local prompt_library = require("plugins.config.codecompanion.prompt_library.prompt_library")
local strategies = require("plugins.config.codecompanion.strategies")
local constants = require("plugins.config.codecompanion.constants")
local adapters = require("plugins.config.codecompanion.adapters")

return {
  "olimorris/codecompanion.nvim",
  enabled = DestNgxVim.plugins.ai.copilot.enabled,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "j-hui/fidget.nvim",
    "banjo/contextfiles.nvim",
  },
  init = function()
    vim.cmd([[cab cc CodeCompanion]])
    require("plugins.config.codecompanion.fidget-spinner"):init()
  end,
  opts = {
    display = {
      action_palette = {
        provider = "default",
      },
      chat = {
        -- show_settings = true,
        render_headers = true,
        show_references = true,
        start_in_insert_mode = true,
      },
    },
    opts = {
      log_level = "DEBUG",
      system_prompt = constants.SYSTEM_PROMPT,
    },
    adapters = adapters.COPILOT,
    strategies = strategies,
    prompt_library = prompt_library,
    extensions = {
      contextfiles = {
        opts = {}
      },
      vectorcode = {
        opts = {
          add_tool = true,
          add_slash_commands = false,
          tool_opts = {}
        },
      }
    },
  },
}
