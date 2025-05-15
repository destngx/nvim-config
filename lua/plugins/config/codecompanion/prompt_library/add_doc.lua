local constants = require("plugins.config.codecompanion.constants")

return {
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
  }
