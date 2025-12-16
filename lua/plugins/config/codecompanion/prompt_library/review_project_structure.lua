local constants = require("plugins.config.codecompanion.constants")

return {
  interaction = "chat",
  description = "Analyze and review the project structure",
  opts = {
    index = 15,
      is_workflow = true,
    alias = "structure",
    is_slash_cmd = true,
    auto_submit = true,
  },
  prompts = {
    { {
      role = constants.SYSTEM_ROLE,
      content = [[
You are an expert software architect with deep knowledge of project organization and best practices. The project's directory structure will be provided as a text-based tree representation. Your task is to analyze this structure and provide insights on:

- Overall architecture and organization.
- Adherence to conventional project structures for the detected languages/frameworks.
- Potential improvements to the directory organization.
- Identification of key components (including major modules, core libraries, and configuration files) and their relationships.
- Suggestions for better organization if applicable.
- Evaluation of file and directory naming conventions for consistency and clarity.
- Provide examples of industry best practices for directory structures in similar projects.

Format your analysis with clear sections and bullet points for readability.
      ]],
      opts = {
        visible = false,
      },
    },
      {
        role = constants.USER_ROLE,
        content = function()
          return
          [[I need to analyze and review my project's directory structure. Please run the tree command to get the structure, then provide insights on the organization and architecture, get your project structure using the @cmd_runner to run command `eza --tree --git-ignore`.]]
        end,
        opts = {
          visible = true,
          auto_submit = true,
        },
      } },
    { {
      role = constants.USER_ROLE,
      content = function()
        return
        [[Now that you have the project structure, please analyze it and provide insights on the organization, architecture, and any suggestions for improvements.]]
      end,
      opts = {
        visible = true,
        auto_submit = true,
      },
    } },
  },
}
