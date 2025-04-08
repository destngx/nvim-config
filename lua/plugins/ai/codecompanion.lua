-- This is custom system prompt for Copilot adapter
-- Base on https://github.com/olimorris/codecompanion.nvim/blob/e7d931ae027f9fdca2bd7c53aa0a8d3f8d620256/lua/codecompanion/config.lua#L639 and https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/d43fab67c328946fbf8e24fdcadfdb5410517e1f/lua/CopilotChat/prompts.lua#L5
local SYSTEM_PROMPT = string.format(
  [[You are an AI programming assistant named "GitHub Copilot".
You are currently plugged in to the Neovim text editor on a user's machine.
When receiving a question, check and fix the grammar of the user request, make it look like native speaker. Then follow the below instructions.

Your tasks include:
- Check the grammar and paraphrase the user's request to make it look like native speaker.
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
local constants = {
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

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
    adapters = {
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "claude-3.7-sonnet",
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
        -- show_settings = true,
        render_headers = true,
        show_references = true,
        start_in_insert_mode = true,
      },
    },
    opts = {
      log_level = "DEBUG",
      system_prompt = SYSTEM_PROMPT,
    },
    strategies = {
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
              n = "<C-c",
              i = "<C-c",
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
          adapters = {
            name = "copilot",
            model = "o3-mini-2025-01-31",
          }
        },
        prompts = {
          {
            role = constants.SYSTEM_ROLE,
            content = COPILOT_EXPLAIN,
            opts = {
              visible = false,
            },
          },
          {
            role = constants.USER_ROLE,
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
        strategy = "workflow",
        description = "Generate a Commit Message for All Changed Files",
        opts = {
          index = 10,
          short_name = "commit",
          is_default = true,
        },
        prompts = {
          { {
            role = constants.SYSTEM_ROLE,
            content = function()
              local is_staged_only = vim.fn.input(
                "Do you want to only generate commit for staged files?\n(default is no): ") or ""

              local diff_content = vim.fn.system("git diff HEAD --no-ext-diff")
              if is_staged_only == "y" or is_staged_only == "yes" then
                diff_content = vim.fn.system("git diff --staged") .. "\n\n-- SHOWING STAGED CHANGES ONLY --"
              end

              return string.format([[
You are an expert in interpreting code changes according to the Conventional Commits specification and generating high-quality commit messages.
With my provide context, your task is to generate commit messages in commitizen style. Follow these rules:
🎯 Expected Output
Return two methods of structuring the commit:
  - Multiple Commits (If Applicable):
      - Suggest how the changes can be logically broken down into multiple commits.
      - For each commit, list the associated files and provide a commit message.
  - Single Commit:
      - If the entire diff can reasonably be grouped into one commit, generate a single, comprehensive commit message.
  - ✅ If both methods result in the same outcome, only return the single commit.
🧠 Thought Process
Think step-by-step and consider the following when generating messages:
  - What was changed and why?
  - What kind of change is it? (e.g. feat, fix, refactor, docs, etc.)
  - Is there a consistent pattern across files?
  - Summarize repetitive actions (e.g., multiple small doc updates = one docs commit).
  - Avoid over-specificity unless it's important.
  - Include a meaningful scope, if applicable.

✍️ Commit Message Format
Follow the commitizen style:
<type>(<scope>): short summary

Here is the 10 latest git commit message:
```diff
%s
```
Here is the current git status:
```diff
%s
```
Here are the diff:
```diff
%s
```
                ]],
                vim.fn.system("git log -10 --oneline"),
                vim.fn.system("git status --short"),
                diff_content)
            end,
            opts = {
              auto_submit = false,
            },
          }, {
            role = constants.USER_ROLE,
            content = "Now generate commmit messages",
            opts = {
              auto_submit = false,
            },
          }, },
          {
            {
              role = constants.USER_ROLE,
              content = "Using @cmd_runner to commit the code with method ",
              opts = {
                auto_submit = false,
              },
            },
          }

        },
      },
      ["Add documentation to the selected code"] = {
        strategy = "inline",
        description = "",
        opts = {
          index = 11,
          default_prompt = true,
          modes = { "v" },
          auto_submit = true,
          user_prompt = false,
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = constants.SYSTEM_ROLE,
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
            role = constants.USER_ROLE,
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
        description = "Refactor the selected code",
        opts = {
          index = 12,
          modes = { "v" },
          short_name = "refactor",
          is_slash_cmd = true,
          auto_submit = true,
          user_prompt = true,
          stop_context_insertion = true,
          adapters = {
            name = "copilot",
            model = "o3-mini-2025-01-31",
          },

        },
        prompts = {
          {
            role = constants.SYSTEM_ROLE,
            content = [[
                When asked to optimize code, follow these steps:
                1. **Analyze the Code**: Understand the functionality and identify potential bottlenecks.
                2. **Implement the Optimization**: Apply the optimizations including best practices to the code.
                3. **Shorten the code**: Remove unnecessary code and refactor the code to be more concise.
                4. **Refactor**: Make sure the code is better at readability.
                5. **Review the Optimized Code**: Ensure the code is optimized for performance and readability. Ensure the code:
                  - Maintains the original functionality.
                  - Is more efficient in terms of time and space complexity.
                  - Follows best practices for readability and maintainability.
                  - Is formatted correctly.

                Use Markdown formatting and include the programming language name at the start of the code block.]],
          },
          {
            role = constants.USER_ROLE,
            content = function(context)
              local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
              return string.format([[
                  Please optimize the selected code:

                  ```%s

                  %s
                  ```
              ]], context.filetype, code)
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      ["Code Review"] = {
        strategy = "chat",
        description = "Review your code",
        opts = {
          index = 13,
          short_name = "review",
          is_slash_cmd = true,
          auto_submit = true,
          adapters = {
            name = "copilot",
            model = "o3-mini-2025-01-31",
          }
        },
        prompts = {
          {
            role = constants.USER_ROLE,
            contains_code = true,
            content = function()
              local number = vim.fn.input("How many commit you want to check?\nLeave empty to review current change ") or
                  ""
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
            role = constants.USER_ROLE,
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
            role = constants.USER_ROLE,
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
            role = constants.USER_ROLE,
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
      },
      ["Mindmap generate"] = {
        strategy = "chat",
        description = "Generate mindmap from the provided context.",
        opts = {
          index = 10,
          short_name = "mindmap",
          is_slash_cmd = true,
          auto_submit = true,
        },
        prompts = {
          {
            role = constants.USER_ROLE,
            content = [[
You are a specialized mind map generator that creates markmap-compatible markdown output. Your task is to analyze the provided text and create a hierarchical mind map structure using markdown syntax.

Rules for generating the mind map:
1. Use markdown headings (##, ###, etc.) for main topics and subtopics
2. Use bullet points (-) for listing details under topics
3. Maintain a clear hierarchical structure from general to specific
4. Keep entries concise and meaningful
5. Include all relevant information from the source text
6. Use proper markdown formatting for:
   - Links: [text](URL)
   - Emphasis: **bold**, *italic*
   - Code: \`inline code\` or code blocks with \`\`\`
   - Tables when needed
   - Lists (both bullet points and numbered lists where appropriate)
7. Always use proper emojis for main topics, if applicable you can also add them for subtopics

Example format:
## 📋 Project Overview
### Key Features
- Feature 1
- Feature 2

Generate a markmap-compatible mind map for the provided text. Also provided this URL in a single line: https://markmap.js.org/repl]],
            opts = {
              visible = false,
            },
          }
        },
      },
      ["Explain like I'm five year olds"] = {
        strategy = "chat",
        description = "Explain the topic in a simple way.",
        opts = {
          index = 11,
          short_name = "eli5",
          is_slash_cmd = true,
          auto_submit = true,
        },
        prompts = {
          {
            role = constants.USER_ROLE,
            content = [[
              You are an expert at breaking down complex topics into simple, easy-to-understand explanations.
              Your explanations should be clear, concise, and engaging, using simple language and relatable examples.
              Avoid jargon, technical terms, and complex concepts.
              Focus on the main points and use analogies, stories, and visual aids to help simplify the topic.
              Explain to me like I'm five years old.
            ]],
            opts = {
              visible = false,
            },
          },
        },
      },
      ["Generate Mermaid chart"] = {
        strategy = "chat",
        description = "Generate mermaid chart/diagram/flow from content",
        opts = {
          index = 12,
          short_name = "mermaid",
          is_slash_cmd = true,
          auto_submit = true,
        },
        prompts = {
          {
            role = constants.USER_ROLE,
            content =
            [[ Analyze the given content, suggest and generate chart/diagram/flow using mermaid.js. At the end, provide the url mermaid.live ]],
            opts = {
              visible = false,
            },
          },
        },
      },
      ["Code workflow"] = {
        strategy = "workflow",
        description = "Use a workflow to guide an LLM in writing code",
        opts = {
          index = 13,
          _default = true,
          short_name = "cw",
          is_slash_cmd = true,
        },
        prompts = {
          {
            {
              role = constants.SYSTEM_ROLE,
              content = function(context)
                return string.format(
                  "You carefully provide accurate, factual, thoughtful, nuanced answers, and are brilliant at reasoning. If you think there might not be a correct answer, you say so. Always spend a few sentences explaining background context, assumptions, and step-by-step thinking BEFORE you try to answer a question. Don't be verbose in your answers, but do provide details and examples where it might help the explanation. You are an expert software engineer for the %s language",
                  context.filetype
                )
              end,
              opts = {
                visible = false,
              },
            },
            {
              role = constants.USER_ROLE,
              content = "I want you to ",
              opts = {
                auto_submit = false,
              },
            },
          },
          {
            {
              role = constants.USER_ROLE,
              content =
              "Great. Now let's consider your code. I'd like you to check it carefully for correctness, style, and efficiency, and give constructive criticism for how to improve it.",
              opts = {
                auto_submit = false,
              },
            },
          },
          {
            {
              role = constants.USER_ROLE,
              content = "Thanks. Now let's revise the code based on the feedback, without additional explanations.",
              opts = {
                auto_submit = false,
              },
            },
          },
        },
      },
      ["context"] = {
        strategy = "chat",
        description = "Chat with context files",
        opts = {
          -- ...
        },
        prompts = {
          {
            role = "user",
            opts = {
              contains_code = true,
            },
            content = function(context)
              local ctx = require("contextfiles.extensions.codecompanion")

              local ctx_opts = {
                -- ...
              }
              local format_opts = {
                -- ...
              }

              return ctx.get(context.filename, ctx_opts, format_opts)
            end,
          },
        },
      }
    },
  },
}
