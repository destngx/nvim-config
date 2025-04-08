local constants = require("plugins.config.codecompanion.constants")

return {
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
        model = "claude-3.7-sonnet-thought",
      }
    },
    prompts = {
      {
        role = constants.SYSTEM_ROLE,
        content = constants.COPILOT_EXPLAIN,
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
  1. Multiple Commits:
      - Suggest how the changes can be logically broken down into multiple commits.
      - For each commit, list the associated files and provide a commit message.
  2. Single Commit:
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
          content = "Using @cmd_runner to stage and commit the files with the result of the method ",
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
          visible = true,
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
        content = [[
Analyze the provided [specify content format],
identify key components and their relationships, and generate a [specify diagram type, e.g., flowchart] using Mermaid.js syntax.
Present the Mermaid.js code snippet, and provide a link to visualize the diagram using mermaid.live.
]],
        opts = {
          visible = true,
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
  ["Chat with context rules"] = {
    strategy = "chat",
    description = "Chat with context files",
    opts = {
      index = 1,
    },
    prompts = {
      {
        role = constants.USER_ROLE,
        opts = {
          contains_code = true,
        },
        content = function(context)
          local ctx = require("contextfiles.extensions.codecompanion")

          local ctx_opts = {
            --   context_dir = ".cursor/rules",
            --   root_markers = { ".git" },
            --   gist_ids = {},
            --   enable_local = true,
          }
          local format_opts = {
            -- prefix = "Here is context for the current file, separated by ``: \n\n---",
            -- suffix = "\n\n---\n\n The following is the user prompt: \n\n---\n\n",
            -- separator = "\n\n---\n\n",
          }

          return ctx.get(context.filename, ctx_opts, format_opts)
        end,
      },
    },
  },
  ["Review Project Structure"] = {
    strategy = "workflow",
    description = "Analyze and review the project structure",
    opts = {
      index = 15,
      short_name = "structure",
      is_slash_cmd = true,
      auto_submit = true,
    },
    prompts = {
      { {
        role = constants.SYSTEM_ROLE,
        content = [[
You are an expert software architect with deep knowledge of project organization and best practices. The project's directory structure will be provided as a text-based tree representation. Your task is to analyze this structure and provide insights on:

- Overall architecture and organization.
- Adherence to conventional project structures for the detected languages/frameworks.
- Potential improvements to the directory organization.
- Identification of key components (including major modules, core libraries, and configuration files) and their relationships.
- Suggestions for better organization if applicable.
- Evaluation of file and directory naming conventions for consistency and clarity.
- Provide examples of industry best practices for directory structures in similar projects.

Format your analysis with clear sections and bullet points for readability.
      ]],
        opts = {
          visible = false,
        },
      },
        {
          role = constants.USER_ROLE,
          content = function()
            return
            [[I need to analyze and review my project's directory structure. Please run the tree command to get the structure, then provide insights on the organization and architecture, get your project structure using the @cmd_runner to run command `eza --tree --git-ignore`.]]
          end,
          opts = {
            visible = true,
            auto_submit = true,
          },
        } },
      { {
        role = constants.USER_ROLE,
        content = function()
          return
          [[Now that you have the project structure, please analyze it and provide insights on the organization, architecture, and any suggestions for improvements.]]
        end,
        opts = {
          visible = true,
          auto_submit = true,
        },
      } },
    },
  },
}
