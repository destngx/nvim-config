local constants = require("plugins.config.codecompanion.constants")

return {
  interaction = "inline",
  description = "",
  opts = {
    index = 14,
    default_prompt = true,
    alias = "spell",
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
}
