local constants = require("plugins.config.codecompanion.constants")

return {
  interaction = "inline",
  description = "Give better naming for the provided code snippet.",
  opts = {
    index = 12,
    modes = { "v" },
    alias = "naming",
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
}
