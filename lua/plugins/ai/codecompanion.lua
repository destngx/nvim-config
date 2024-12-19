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
        render_headers = false,
        show_references = true,
        show_header_separator = true,
      },
      diff = {
        provider = "diff",
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
        slash_commands = {
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
      }
    },
    prompt_library = {
      ["Generate a Commit Message for All Changed Files"] = {
        strategy = "chat",
        description = "",
        opts = {
          index = 10,
          default_prompt = true,
          slash_cmd = "scommit",
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              return string.format([[
You are an expert at following the Conventional Commit specification.
Given the git diff listed below, please generate a commit message for me.
If I should break it down into multiple commit, please suggest me and list the files for each commit.
Think step-by-step about what was actually changed and keep the commit message focused on these changes.
Use commitizen style for the commit message. Include the scope if possible.
Focus on:
1. What was changed and why.
2. Summarize repetitve changes. E.g. do not state every single added documentation or refactoring, but summarize it.
3. Carefully inspect the diff and make sure you understand the changes.
4. Observe the kind of changes. For example, is it documentation, comments, refactored code or new code?
Here are the git status:
```diff
%s
```
Here are the diff:
```diff
%s
```

                ]], vim.fn.system("git status --short"), vim.fn.system("git diff --no-ext-diff"))
            end,
          },
        },
      },
      ["Generate a Commit Message for Staged Files"] = {
        strategy = "inline",
        description = "",
        opts = {
          index = 10,
          default_prompt = true,
          slash_cmd = "scommit",
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              return string.format([[
You are an expert at following the Conventional Commit specification.
Given the git diff listed below, please generate a commit message for me.
If I should break it down into multiple commit, please suggest me and list the files for each commit.
Think step-by-step about what was actually changed and keep the commit message focused on these changes.
Use commitizen style for the commit message. Include the scope if possible.
Focus on:
1. What was changed and why.
2. Summarize repetitve changes. E.g. do not state every single added documentation or refactoring, but summarize it.
3. Carefully inspect the diff and make sure you understand the changes.
4. Observe the kind of changes. For example, is it documentation, comments, refactored code or new code?

Here are the git status:
```diff
%s
```
Here are the staged changes:
```diff
%s
```
                ]], vim.fn.system("git status --short"), vim.fn.system("git diff --staged"))
            end,
          },
        },
      },
      ["Add documentation to the selected code"] = {
        strategy = "inline",
        description = "",
        opts = {
          index = 11,
          default_prompt = true,
          modes = { "v" },
          slash_cmd = "doc",
          auto_submit = true,
          user_prompt = false,
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = "system",
            content = [[
                When asked to add documentation, follow these steps:
                1. **Identify Key Points**: Carefully read the provided code to understand its functionality.
                2. **Plan the Documentation**: Describe the key points to be documented in pseudocode, detailing each step.
                3. **Implement the Documentation**: Write the accompanying documentation in the same file or a separate file.
                4. **Review the Documentation**: Ensure that the documentation is comprehensive and clear. Ensure the documentation:
                  - Includes necessary explanations.
                  - Helps in understanding the code's functionality.
                  - Add parameters, return values, and exceptions documentation.
                  - Follows best practices for readability and maintainability.
                  - Is formatted correctly.

                Use Markdown formatting and include the programming language name at the start of the code block.]],
            opts = {
              visible = true,
            },
          },
          {
            role = "user",
            content = function(context)
              local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

              return "Please document the selected code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```\n\n"
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      ["Refactor the selected code for readability, maintainability and performances"] = {
        strategy = "chat",
        description = "",
        opts = {
          index = 12,
          default_prompt = true,
          modes = { "v" },
          slash_cmd = "refactor",
          auto_submit = true,
          user_prompt = false,
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = "system",
            content = [[
                When asked to optimize code, follow these steps:
                1. **Analyze the Code**: Understand the functionality and identify potential bottlenecks.
                2. **Implement the Optimization**: Apply the optimizations including best practices to the code.
                3. **Shorten the code**: Remove unnecessary code and refactor the code to be more concise.
                3. **Review the Optimized Code**: Ensure the code is optimized for performance and readability. Ensure the code:
                  - Maintains the original functionality.
                  - Is more efficient in terms of time and space complexity.
                  - Follows best practices for readability and maintainability.
                  - Is formatted correctly.

                Use Markdown formatting and include the programming language name at the start of the code block.]],
            opts = {
              visible = false,
            },
          },
          {
            role = "user",
            content = function(context)
              local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

              return "Please optimize the selected code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```\n\n"
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      ["Last Commit Code Review"] = {
        strategy = "chat",
        description = "",
        opts = {
          index = 13,
          default_prompt = true,
          slash_cmd = "review",
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              local number = vim.fn.input("How many commit you want to check? ") or 1
              local git_history_cmd = string.format("git log --oneline -n %s", number)
              local git_diff_cmd = string.format("git diff HEAD~%s", number)
              return string.format([[
You are a senior developer and an expert in code review, code cleaning, and coding conventions. Your task is to review the provided code.

1. Identify the programming language.
1. Include the diff changes and the file name. Ignore lock files, changelog, and other unnecessary files. For the dependencies file, leave comments and do not suggest changes if not related. If updates of dependencies include breaking changes, recommend required actions.
3. Provide comments about the code, tell me what is not good, and why?
4. Suggest fixes based on best practices of that code language.
5. Check spelling and grammar.
6. Offer solutions for any improvements.

Ensure your feedback is clear, specific, and actionable.

Here are the commits
```commit
 %s
```

Here are the diff changes:
```diff
%s
```
              ]]
              , vim.fn.system(git_history_cmd), vim.fn.system(git_diff_cmd))
            end,
          },
        },
      },
      ["Generate Pull Request Description"] = {
        strategy = "chat",
        description = "",
        opts = {
          index = 13,
          default_prompt = true,
          slash_cmd = "pr",
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              return string.format([[
                You are an expert at writing detailed and clear pull request descriptions.
                Please create a pull request message following standard convention from the provided diff changes.
                Ensure the title, description, type of change, checklist, related issues, and additional notes sections are well-structured and informative."
                ```diff
                %s
                ```]], vim.fn.system("git diff $(git merge-base HEAD main)...HEAD"))
            end,
          },
        },
      },
      ["Check Spelling, Correct grammar and reformulate"] = {
        strategy = "inline",
        description = "",
        opts = {
          index = 14,
          default_prompt = true,
          slash_cmd = "spell",
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = false,
            content = function(context)
              local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
              return string.format("Correct grammar and reformulate:\n\n %s", text)
            end,
          },
        },
      },
    },
  },
}
