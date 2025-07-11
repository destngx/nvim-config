local constants = require("plugins.config.codecompanion.constants")

return {
  strategy = "chat",
  description = "Chat with context files",
  opts = {
    -- is_slash_cmd = true,
    short_name = "context_file",
    index = 1,
  },
  prompts = {
    {
      role = constants.USER_ROLE,
      opts = {
        contains_code = false,
        auto_submit = true,
      },
      content = function()
        return
        "You have the tools @{full_stack_dev} @{web_search} @{vectorcode_toolbox} @{mcp} so you can run terminal commands, CRUD files and edit current buffer. You can search the web to check new documents or searching for extra knowledge using the tool @{web_search}. You can also use the tool @{vectorcode_toolbox} to vectorise and search for code snippets in your codebase. With MCP you can search newest documents using Context7, Do sequential thinking. "
      end,
    },
    {
      role = constants.SYSTEM_ROLE,
      opts = {
        contains_code = false,
        auto_submit = true,
        visible = false,
      },
      content = function(context)
        local ctx = require("codecompanion").extensions.contextfiles
        -- You can check example context rules at https://cursor.directory/rules

        local ctx_opts = {
          --   context_dir = ".cursor/rules",
          --   root_markers = { ".git" },
          --   gist_ids = {},
          --   enable_local = true,
        }
        local format_opts = {
          prefix = "\n\nFollow the below rules, and extra contexts for you, separated by: \n\n---",
          suffix = "\n\n---\n\n The following is the user prompt: \n\n",
          -- separator = "\n\n---\n\n",
        }

        -- Get the context from contextfiles.nvim based on the current file
        -- Handle error case - return empty string if context cannot be fetched
        local success, context_content = pcall(ctx.get, context.filename, ctx_opts, format_opts)
        if not success or not context_content then
          context_content = "\n\n--- No additional project context available ---\n\n"
        end

        -- Combine context with the LLM's system instructions for brainstorming
        return string.format([[
You are an expert-level software architect and product strategist.
You always use the latest technology, and familiar with latest best practices, especially what I ask you.
Your goal is to help me brainstorm a new feature by creating a clear, actionable, step-by-step plan.

GUIDELINES:
1.  **Analyze Context:** You have been provided with project context below. All suggestions must align with the patterns and technologies found in this context.
2.  **Think in Steps:** Break down every feature into a high-level plan (e.g., Step 1: Database Schema, Step 2: API Endpoints, Step 3: UI Components).
3.  **No Code Yet:** Do not write any code. Focus entirely on the plan, the 'what' and the 'why'.
4.  **Ask to Proceed:** After each response, ask if I'm ready to move to the next step or if I want to refine the current one.
5.  **Be Truthful:** If you're unsure about my requirements, ask specific questions to clarify before proceeding. If you think my ideas is not correct, please say so. If you do not know the answer, please say so, never guessing.


%s -- This inserts the "contextfiles" content
          ]], context_content)
      end,
    },
    {
      role = constants.USER_ROLE,
      content =
      [[
List all files that have been referenced in "contextfiles" for this conversation using your tool.
If context files are available, get their content as additional background information for our discussion.

Before we begin, please confirm what project files or codebase sections you have access to. Provide a brief overview of:
- File names and their purposes
- Main functional areas covered
- Key components or modules included

This will help establish the scope of our conversation and ensure we're working with the same understanding of the available context.
]],
      opts = {
        auto_submit = true,
        visible = true,
      },
    },
    {
      role = constants.USER_ROLE,
      opts = {
        contains_code = false,
        auto_submit = true,
      },
      content = function(context)
        return
            "\n\nI will give you extra context with current file content #{buffer} and path: `" ..
            context.filename .. "`"
      end,
    },
    {
      role = constants.USER_ROLE,
      content =
      "My request is: \n\n > ",
      opts = {
        auto_submit = false, -- User types their initial request
      },
    },
  },
}
