local prompt_library = require("plugins.config.codecompanion.prompt_library.prompt_library")
local interactions = require("plugins.config.codecompanion.interactions")

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
    -- "banjo/contextfiles.nvim",
    "ravitemer/codecompanion-history.nvim",
    { "franco-ruggeri/codecompanion-spinner.nvim", opts = {} }
  },
  init = function()
    vim.cmd([[cab cc CodeCompanion]])
  end,
  opts = function()
    local extensions = {
      -- contextfiles = {
      --   opts = {}
      -- },
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          show_result_in_chat = true, -- Show mcp tool results in chat
          make_vars = true,           -- Convert resources to #variables
          make_slash_commands = true, -- Add prompts as /slash commands
        }
      },
      history = {
        enabled = true,
        opts = {
          -- Keymap to open history from chat buffer (default: gh)
          keymap = "gh",
          -- Keymap to save the current chat manually (when auto_save is disabled)
          save_chat_keymap = "sc",
          -- Save all chats by default (disable to save only manually using 'sc')
          auto_save = true,
          -- Number of days after which chats are automatically deleted (0 to disable)
          expiration_days = 30,
          -- Picker interface (auto resolved to a valid picker)
          picker = "fzf-lua", --- ("telescope", "snacks", "fzf-lua", or "default")
          ---Optional filter function to control which chats are shown when browsing
          chat_filter = nil,  -- function(chat_data) return boolean end
          -- Customize picker keymaps (optional)
          picker_keymaps = {
            rename = { n = "r", i = "<M-r>" },
            delete = { n = "d", i = "<M-d>" },
            duplicate = { n = "<C-y>", i = "<C-y>" },
          },
          ---Automatically generate titles for new chats
          auto_generate_title = true,
          title_generation_opts = {
            ---Adapter for generating titles (defaults to current chat adapter)
            adapter = nil,               -- "copilot"
            ---Model for generating titles (defaults to current chat model)
            model = nil,                 -- "gpt-4o"
            ---Number of user prompts after which to refresh the title (0 to disable)
            refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
            ---Maximum number of times to refresh the title (default: 3)
            max_refreshes = 3,
            format_title = function(original_title)
              -- this can be a custom function that applies some custom
              -- formatting to the title.
              return original_title
            end
          },
          ---On exiting and entering neovim, loads the last chat on opening chat
          continue_last_chat = false,
          ---When chat is cleared with `gx` delete the chat from history
          delete_on_clearing_chat = false,
          ---Directory path to save the chats
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
          ---Enable detailed logging for history extension
          enable_logging = false,

          -- Summary system
          summary = {
            -- Keymap to generate summary for current chat (default: "gcs")
            create_summary_keymap = "gcs",
            -- Keymap to browse summaries (default: "gbs")
            browse_summaries_keymap = "gbs",

            generation_opts = {
              adapter = nil,               -- defaults to current chat adapter
              model = nil,                 -- defaults to current chat model
              context_size = 90000,        -- max tokens that the model supports
              include_references = true,   -- include slash command content
              include_tool_outputs = true, -- include tool execution results
              system_prompt = nil,         -- custom system prompt (string or function)
              format_summary = nil,        -- custom function to format generated summary e.g to remove <think/> tags from summary
            },
          },

          -- Memory system (requires VectorCode CLI)
          memory = {
            -- Automatically index summaries when they are generated
            auto_create_memories_on_summary_generation = true,
            -- Path to the VectorCode executable
            vectorcode_exe = "vectorcode",
            -- Tool configuration
            tool_opts = {
              -- Default number of memories to retrieve
              default_num = 10
            },
            -- Enable notifications for indexing progress
            notify = true,
            -- Index all existing memories on startup
            -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
            index_on_startup = false,
          },
        }
      }
    }

    -- Conditionally add vectorcode extension if enabled
    if DestNgxVim.plugins.ai.vectorcode.enabled then
      extensions.vectorcode = {
        opts = {
          add_tool = true,
          add_slash_commands = false,
          tool_opts = {
            chunk_mode = true,
          }
        },
      }
    end

    interactions.chat = interactions.chat or {}
    interactions.chat.opts = vim.tbl_deep_extend("force", interactions.chat.opts or {}, {
      system_prompt = constants.SYSTEM_PROMPT,
    })

    return {
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
      },
      adapters = {
        http = adapters.COPILOT,
      },
      interactions = interactions,
      prompt_library = prompt_library,
      rules = {
        opts = {
          chat = {
            enabled = true,
          },
        },
      },
      extensions = extensions,
    }
  end,
}
