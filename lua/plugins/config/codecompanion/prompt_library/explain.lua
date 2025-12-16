local constants = require("plugins.config.codecompanion.constants")

return {
  interaction = "chat",
  description = "Explain how code in a buffer works",
  opts = {
    index = 4,
    default_prompt = true,
    modes = { "v" },
    alias = "explain",
    auto_submit = true,
    user_prompt = false,
    stop_context_insertion = true,
    adapter = {
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
}
