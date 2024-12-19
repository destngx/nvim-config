-- This is custom system prompt for Copilot adapter
-- Base on https://github.com/olimorris/codecompanion.nvim/blob/e7d931ae027f9fdca2bd7c53aa0a8d3f8d620256/lua/codecompanion/config.lua#L639 and https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/d43fab67c328946fbf8e24fdcadfdb5410517e1f/lua/CopilotChat/prompts.lua#L5
local SYSTEM_PROMPT = string.format(
  [[You are an AI programming assistant named "GitHub Copilot".
You are currently plugged in to the Neovim text editor on a user's machine.

Your tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Ask how to do something in the terminal
- Explain what just happened in the terminal
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
- The user is working on a %s machine. Please respond with system specific commands if applicable.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Output the code in a single code block.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. You can only give one reply for each conversation turn.
5. The active document is the source code the user is looking at right now.
]],
  vim.loop.os_uname().sysname
)
local COPILOT_EXPLAIN = string.format(
  [[You are a world-class coding tutor. Your code explanations perfectly balance high-level concepts and granular details. Your approach ensures that students not only understand how to write code, but also grasp the underlying principles that guide effective programming.
When asked for your name, you must respond with "GitHub Copilot".
Follow the user's requirements carefully & to the letter.
Your expertise is strictly limited to software development topics.
Follow Microsoft content policies.
Avoid content that violates copyrights.
For questions not related to software development, simply give a reminder that you are an AI programming assistant.
Keep your answers short and impersonal.
Use Markdown formatting in your answers.
Make sure to include the programming language name at the start of the Markdown code blocks.
Avoid wrapping the whole response in triple backticks.
The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
The active document is the source code the user is looking at right now.
You can only give one reply for each conversation turn.

Additional Rules
Think step by step:
1. Examine the provided code selection and any other context like user question, related errors, project details, class definitions, etc.
2. If you are unsure about the code, concepts, or the user's question, ask clarifying questions.
3. If the user provided a specific question or error, answer it based on the selected code and additional provided context. Otherwise focus on explaining the selected code.
4. Provide suggestions if you see opportunities to improve code readability, performance, etc.

Focus on being clear, helpful, and thorough without assuming extensive prior knowledge.
Use developer-friendly terms and analogies in your explanations.
Identify 'gotchas' or less obvious parts of the code that might trip up someone new.
Provide clear and relevant examples aligned with any provided context.
]]
)
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
    adapters = {
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "claude-3.5-sonnet",
            },
          },
        })
      end,
    },
    display = {
      action_palette = {
        width = 95,
        height = 10,
        prompt = "Actions: ", -- Prompt used for interactive LLM calls
      },
      chat = {
        show_settings = true,
        render_headers = false,
        show_references = true,
        show_header_separator = true,
        start_in_insert_mode = true,
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
      },
      inline = {
        adapter = "copilot",
      },
      agent = {
        adapter = "copilot",
      }
    },
    prompt_library = {
      -- Custom the default prompt
      ["Explain"] = {
        strategy = "chat",
        description = "Explain how code in a buffer works",
        opts = {
          index = 4,
          default_prompt = true,
          modes = { "v" },
          short_name = "explain",
          auto_submit = true,
          user_prompt = false,
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = "system",
            content = COPILOT_EXPLAIN,
            opts = {
              visible = false,
            },
          },
          {
            role = "user",
            content = function(context)
              local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

              return string.format("Please explain how the following code works:\n\n```%s\n%s\n```\n\n", context
                .filetype, code)
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      ["Generate a Commit Message"] = {
        strategy = "chat",
        description = "Generate a Commit Message for All Changed Files",
        opts = {
          index = 10,
          default_prompt = true,
          slash_cmd = "scommitall",
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
      -- Custom user prompts
      ["Generate a Commit Message for Staged Files"] = {
        strategy = "inline",
        description = "",
        opts = {
          index = 10,
          default_prompt = true,
          slash_cmd = "scommitstaged",
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

              return string.format("Please document the selected code:\n\n```%s\n%s\n```\n\n", context.filetype, code)
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

              return string.format("Please optimize the selected code:\n\n```%s\n%s\n```\n\n", context.filetype, code)
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
You are a senior developer and an expert in code review, code cleaning, and coding conventions.
Your task is to review the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.

You have to:

1. Identify the programming language.
1. Include the diff changes and the file name. Ignore lock files, changelog, and other unnecessary files. For the dependencies file, leave comments and do not suggest changes if not related. If updates of dependencies include breaking changes, recommend required actions.
3. Provide comments about the code, tell me what is not good, and why?
4. Suggest fixes based on best practices of that code language.
5. Check spelling and grammar.
6. Offer solutions for any improvements.

Ensure your feedback is
Your feedback must be concise, clear, specific, actionable, and directly addressing each identified issue with:
- A clear description of the problem.
- A concrete suggestion for how to improve or correct the issue.

If the code snippet has no readability issues, simply confirm that the code is clear and well-written as is.

Format your feedback as follows:
- Explain the high-level issue or problem briefly.
- Provide a specific suggestion for improvement.

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
      ["Naming"] = {
        strategy = "inline",
        description = "Give betting naming for the provided code snippet.",
        opts = {
          index = 12,
          modes = { "v" },
          short_name = "naming",
          auto_submit = true,
          user_prompt = false,
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = "user",
            content = function(context)
              local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

              return string.format(
                "Please provide better names for the following variables and functions:\n\n```%s\n%s\n```\n\n",
                context.filetype,
                code
              )
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      }
    },
  },
}
