local constants = require("plugins.config.codecompanion.constants")

return {
  strategy = "workflow", -- This must be 'workflow'
  description = "Start a feature development brainstorming session with project context.",
  opts = {
    index = 1,
    short_name = "brainstorm",
  },
  prompts = {
    -- FIRST PROMPT GROUP: Inject Context Files and Initial Feature Idea
    {
      {
        role = constants.USER_ROLE, -- Use SYSTEM_ROLE for context to the LLM
        content = function(context)
          local ctx = require("codecompanion").extensions.contextfiles
          -- Options for contextfiles.nvim (adjust as per your setup)
          local ctx_opts = {
            -- context_dir = ".contextfiles", -- Example: if your rules are in a .contextfiles directory
            -- root_markers = { ".git" }, -- Example: look for .git to define project root
            -- enable_local = true, -- Enable local rules in the current project
          }
          local format_opts = {
            prefix = "Here's relevant project context, separated by ---. Use this to inform your plan:\n\n---",
            suffix = "\n\n---\n\n",
            separator = "\n\n---\n\n",
          }

          -- Get the context from contextfiles.nvim based on the current file
          local context_content = ctx.get(context.filename, ctx_opts, format_opts)

          -- Combine context with the LLM's system instructions for brainstorming
          return string.format([[
You are an expert-level software architect and product strategist.
Your goal is to help me brainstorm a new feature by creating a clear, actionable, step-by-step plan.

GUIDELINES:
1.  **Analyze Context:** You have been provided with project context below. All suggestions must align with the patterns and technologies found in this context.
2.  **Think in Steps:** Break down every feature into a high-level plan (e.g., Step 1: Database Schema, Step 2: API Endpoints, Step 3: UI Components).
3.  **No Code Yet:** Do not write any code. Focus entirely on the plan, the 'what' and the 'why'.
4.  **Ask to Proceed:** After each response, ask if I'm ready to move to the next step or if I want to refine the current one.


%s -- This inserts the context files content
          ]], context_content)
        end,
        opts = {
          visible = true,    -- Keep this system prompt hidden from the user in chat
          auto_submit = true, -- Important: Set this to false for the initial user input
        },
      },
      {
        role = constants.USER_ROLE,
        content =
        [[

Using @full_stack_dev tool to get file list in the contextfiles, then get the content of those files as context
Before we proceed, can you confirm which project files or parts of the codebase you've received as context for this conversation? Please list them briefly or describe the main areas.
]],
        opts = {
          auto_submit = true,
          visible = true, -- Make this prompt visible so you see the question
        },
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
    {
      {
        role = constants.USER_ROLE,
        content =
        "That's a solid high-level plan. Let's zoom in on **Step 1**. What specific files would need to be created or modified? For each file, give me a one-sentence summary of its core responsibility.",
        opts = { auto_submit = true },
      },
    },
    -- e.g., error handling, testing strategy, etc.
    {
      {
        role = constants.USER_ROLE,
        content =
        "Excellent. Now, thinking about the plan so far, what are the most important test cases we need to consider? List 3-5 critical tests (e.g., unit, integration) and any potential edge cases you see.",
        opts = { auto_submit = true },
      },
    },

    --
    -- GROUP 4: FINAL CHECK BEFORE CODING
    --
    {
      {
        role = constants.USER_ROLE,
        content =
        "This plan looks solid. Is there anything we might have missed? Any dependencies, potential blockers, or alternative approaches we should consider before we start writing code?",
        opts = { auto_submit = true },
      },
    },
  },
}
