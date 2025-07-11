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
    { "franco-ruggeri/codecompanion-spinner.nvim", opts = {} }
  },
  init = function()
    vim.cmd([[cab cc CodeCompanion]])
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
          tool_opts = {
            chunk_mode = true,
          }
        },
      },
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          show_result_in_chat = true, -- Show mcp tool results in chat
          make_vars = true,         -- Convert resources to #variables
          make_slash_commands = true, -- Add prompts as /slash commands
        }
      }
    },
  },
}
