local constants = require("plugins.config.codecompanion.constants")

return {
  strategy = "chat",
  description = "Chat with context files",
  opts = {
    is_slash_cmd = true,
    short_name = "context_file",
    index = 1,
  },
  prompts = {
    {
      role = constants.USER_ROLE,
      opts = {
        contains_code = true,
        auto_submit = true,
      },
      content = function(context)
        local ctx = require("codecompanion").extensions.contextfiles
        -- You can check example context rules at https://cursor.directory/rules

        local ctx_opts = {
          --   context_dir = ".cursor/rules",
          --   root_markers = { ".git" },
          --   gist_ids = {},
          --   enable_local = true,
        }
        local format_opts = {
          -- prefix = "Here is context for the current file, separated by ``: \n\n---",
          -- suffix = "\n\n---\n\n The following is the user prompt: \n\n---\n\n",
          -- separator = "\n\n---\n\n",
        }

        return ctx.get(context.filename, ctx_opts, format_opts)
      end,
    },
  },
}
