local constants = require("plugins.config.codecompanion.constants")

return {
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
  }
