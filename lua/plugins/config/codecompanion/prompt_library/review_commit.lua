local constants = require("plugins.config.codecompanion.constants")

return {
    strategy = "chat",
    description = "Review your code",
    opts = {
      index = 13,
      short_name = "review",
      is_slash_cmd = true,
      auto_submit = true,
      adapters = {
        name = "copilot",
        model = "o3-mini-2025-01-31",
      }
    },
    prompts = {
      {
        role = constants.USER_ROLE,
        contains_code = true,
        content = function()
          local number = vim.fn.input("How many commit you want to check?\nLeave empty to review current change ") or
              ""
          local git_history_cmd = string.format("git log --oneline -n %s", number)
          local git_diff_cmd = string.format("git diff HEAD~%s", number)
          return string.format([[
You are a senior developer and an expert in code review, code cleaning, and coding conventions.
Your task is to review the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.

You have to:

1. Identify the programming language.
1. Include the diff changes and the file name. Ignore lock files, changelog, and other unnecessary files. For the dependencies file, leave comments and do not suggest changes if not related. If updates of dependencies include breaking changes, recommend required actions.
3. Provide comments about the code, tell me what is not good, and why?
4. Suggest fixes based on best practices of that code language.
5. Check spelling and grammar.
6. Offer solutions for any improvements.

Ensure your feedback is
Your feedback must be concise, clear, specific, actionable, and directly addressing each identified issue with:
- A clear description of the problem.
- A concrete suggestion for how to improve or correct the issue.

If the code snippet has no readability issues, simply confirm that the code is clear and well-written as is.

Format your feedback as follows:
- Explain the high-level issue or problem briefly.
- Provide a specific suggestion for improvement.

Here are the commits
```commit
 %s
```

Here are the diff changes:
```diff
%s
```
              ]]
          , vim.fn.system(git_history_cmd), vim.fn.system(git_diff_cmd))
        end,
      },
    },
  }
