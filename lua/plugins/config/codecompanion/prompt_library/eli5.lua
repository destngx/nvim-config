local constants = require("plugins.config.codecompanion.constants")

return {
    interaction = "chat",
    description = "Explain the topic in a simple way.",
    opts = {
      index = 11,
      alias = "eli5",
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
  }
