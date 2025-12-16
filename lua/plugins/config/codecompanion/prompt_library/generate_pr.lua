local constants = require("plugins.config.codecompanion.constants")

return {
  interaction = "chat",
  description = "",
  opts = {
    index = 13,
    default_prompt = true,
    alias = "pr",
    auto_submit = true,
  },
  prompts = {
    {
      role = constants.USER_ROLE,
      contains_code = true,
      content = function()
        -- Get git root directory
        local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
        if vim.v.shell_error ~= 0 then
          return "Error: Not in a git repository"
        end
        
        local git_diff = vim.fn.system(string.format("cd '%s' && git diff $(git merge-base HEAD main)...HEAD", git_root))
        
        return string.format([[
                You are an expert at writing detailed and clear pull request descriptions.
                Please create a pull request message following standard convention from the provided diff changes.
                Ensure the title, description, type of change, checklist, related issues, and additional notes sections are well-structured and informative."
                ```diff
                %s
                ```]], git_diff)
      end,
    },
  },
}
