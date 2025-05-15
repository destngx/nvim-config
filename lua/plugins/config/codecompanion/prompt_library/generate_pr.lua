local constants = require("plugins.config.codecompanion.constants")

return {
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
}
