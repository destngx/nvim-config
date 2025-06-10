local constants = require("plugins.config.codecompanion.constants")

return {
  strategy = "workflow",
  description = "Generate a Commit Message for All Changed Files",
  opts = {
    index = 10,
    short_name = "commit",
    is_default = true,
  },
  prompts = {
    { {
      role = constants.SYSTEM_ROLE,
      content = function()
        local is_staged_only = vim.fn.input(
          "Do you want to only generate commit for staged files?\n(default is no): ") or ""

        local diff_content = vim.fn.system("git diff HEAD --no-ext-diff")
        if is_staged_only == "y" or is_staged_only == "yes" then
          diff_content = vim.fn.system("git diff --staged") .. "\n\n-- SHOWING STAGED CHANGES ONLY --"
        end

        return string.format([[
You are an expert in interpreting code changes according to the Conventional Commits specification and generating high-quality commit messages.
With my provide context, your task is to generate commit messages in commitizen style. Follow these rules:
🎯 Expected Output
Return two methods of structuring the commit:
  1. Multiple Commits:
      - Suggest how the changes can be logically broken down into multiple commits.
      - For each commit, list the associated files and provide a commit message.
  2. Single Commit:
      - If the entire diff can reasonably be grouped into one commit, generate a single, comprehensive commit message.
  - ✅ If both methods result in the same outcome, only return the single commit.
🧠 Thought Process
Think step-by-step and consider the following when generating messages:
  - What was changed and why?
  - What kind of change is it? (e.g. feat, fix, refactor, docs, etc.)
  - Is there a consistent pattern across files?
  - Summarize repetitive actions (e.g., multiple small doc updates = one docs commit).
  - Avoid over-specificity unless it's important.
  - Include a meaningful scope, based on the files changed.

✍️ Commit Message Format
Follow the commitizen style:
<type>(<scope>): short summary

Here is the 10 latest git commit message:
```diff
%s
```
Here is the current git status:
```diff
%s
```
Here are the diff:
```diff
%s
```
                ]],
          vim.fn.system("git log -10 --oneline"),
          vim.fn.system("git status --short"),
          diff_content)
      end,
      opts = {
        auto_submit = false,
      },
    }, {
      role = constants.USER_ROLE,
      content = "Now generate commmit messages",
      opts = {
        auto_submit = true,
      },
    }, },
    {
      {
        role = constants.USER_ROLE,
        content =
        "Using @cmd_runner to run a single command that using the result of the method multiple commits (if it not available, fallback to single commit method) to stage and commit the files based on the results, avoid adding duplicate files. After finish, run `git log --oneline <number-of-commits>` to verify the commits.",
        opts = {
          auto_submit = false,
        },
      },
      {
        role = constants.USER_ROLE,
        content =
        "Run `git log --oneline <number-of-commits>` to verify the commits ",
        opts = {
          auto_submit = true,
        },
      },
    }

  },
}
