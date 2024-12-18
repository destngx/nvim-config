return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = DestNgxVim.plugins.ai.copilot.enabled,
    version = "3.1.0",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    event = "VeryLazy",
    opts = {
      show_help = false,
      auto_follow_cursor = false,
      prompts = {
        -- Code related prompts
        Explain = "Explain how it works.",
        Review = "Review the following code and provide concise suggestions.",
        Tests = "Briefly explain how the selected code works, then generate unit tests.",
        Refactor = "Refactor the code to improve clarity and readability.",
        BetterNamings = "Please provide better names for the following variables and functions.",
        FixCode = "Please fix the following code to make it work as intended.",
        FixError = "Please explain the error in the following text and provide a solution.",
        -- Text related prompts
        TextSummarize = "Please summarize the following text.",
        TextSpelling = "Please correct any grammar and spelling errors in the following text.",
        TextWording = "Please improve the grammar and wording of the following text.",
        TextConcise = "Please rewrite the following text to make it more concise.",
      },
    },
    context = "buffer",
    build = "make tiktoken",
    -- build = function()
    --   vim.defer_fn(function()
    --     vim.cmd("UpdateRemotePlugins")
    --     vim.notify("CopilotChat - Updated remote plugins. Please restart Neovim.")
    --   end, 3000)
    -- end,
    keys = {
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "Quick Chat (Current buffer)",
        mode = { "n", "v" },
      },
      -- Show prompts actions with fzf-lua
      {
        "<leader>ap",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
        mode = { "n", "v" },
      },
      {
        "<leader>aa",
        "<cmd>CopilotChat<cr>",
        desc = "CopilotChat - Toggle ", -- Toggle vertical split
        mode = { "n", "v" },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")
      -- Use unnamed register for the selection
      opts.selection = select.unnamed

      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      opts.question_header = "  " .. user .. " "
      opts.answer_header = "  Copilot "
      -- Override the git prompts message
      opts.prompts.Commit = {
        prompt =
        'Write commit message with commitizen convention. Write clear, informative commit messages that explain the "what" and "why" behind changes, not just the "how".',
        selection = select.gitdiff,
      }
      opts.prompts.CommitStaged = {
        prompt =
        'Write commit message for the change with commitizen convention. Write clear, informative commit messages that explain the "what" and "why" behind changes, not just the "how".',
        selection = function(source)
          return select.gitdiff(source, true)
        end,
      }

      -- Setup CMP integration
      -- if pcall(require, "cmp") then
      --   require("CopilotChat.integrations.cmp").setup()
      -- end
      opts.chat_autocomplete = true

      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false

          -- Get current filetype and set it to markdown if the current filetype is copilot-chat
          vim.bo.filetype = "markdown"
        end,
      })

      chat.setup(opts)
    end,
  }
}
