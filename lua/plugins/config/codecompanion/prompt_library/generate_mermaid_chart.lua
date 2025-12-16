local constants = require("plugins.config.codecompanion.constants")

return {
    interaction = "chat",
    description = "Generate mermaid chart/diagram/flow from content",
    opts = {
      index = 12,
      alias = "mermaid",
      is_slash_cmd = true,
      auto_submit = true,
    },
    prompts = {
      {
        role = constants.USER_ROLE,
        content = [[
Analyze the provided [specify content format],
identify key components and their relationships, and generate a [specify diagram type, e.g., flowchart] using Mermaid.js syntax.

Do not use `()` char

Present the Mermaid.js code snippet.
]],
        opts = {
          visible = true,
        },
      },
    },
  }
