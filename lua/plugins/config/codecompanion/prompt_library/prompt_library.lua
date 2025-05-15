local constants = require("plugins.config.codecompanion.constants")

return {
  -- Custom the default prompt
  ["Explain"] = require("plugins.config.codecompanion.prompt_library.explain"),
  ["Generate a Commit Message"] = require("plugins.config.codecompanion.prompt_library.generate_commit"),
  ["Add documentation to the selected code"] = require("plugins.config.codecompanion.prompt_library.add_doc"),
  ["Refactor the selected code for readability, maintainability and performances"] = require(
  "plugins.config.codecompanion.prompt_library.refactor_code"),
  ["Code Review"] = require("plugins.config.codecompanion.prompt_library.review_commit"),
  ["Generate Pull Request Description"] = require("plugins.config.codecompanion.prompt_library.generate_pr"),
  ["Check Spelling, Correct grammar and reformulate"] = require(
  "plugins.config.codecompanion.prompt_library.check_spelling"),
  ["Naming"] = require("plugins.config.codecompanion.prompt_library.naming"),
  ["Mindmap generate"] = require("plugins.config.codecompanion.prompt_library.generate_mindmap"),
  ["Explain like I'm five year olds"] = require("plugins.config.codecompanion.prompt_library.eli5"),
  ["Generate Mermaid chart"] = require("plugins.config.codecompanion.prompt_library.generate_mermaid_chart"),
  ["Code workflow"] = require("plugins.config.codecompanion.prompt_library.code_with_workflow"),
  ["Chat with context rules"] = require("plugins.config.codecompanion.prompt_library.chat_with_context_file"),
  ["Review Project Structure"] = require("plugins.config.codecompanion.prompt_library.review_project_structure"),
}
