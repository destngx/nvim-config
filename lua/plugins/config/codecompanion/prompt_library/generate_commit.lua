local constants = require("plugins.config.codecompanion.constants")

return {
  interaction = "chat",
  description = "Generate a Commit Message for All Changed Files",
  opts = {
    index = 10,
    is_workflow = true,
    alias = "commit",
    is_default = true,
  },
  prompts = {
    { {
      role = constants.SYSTEM_ROLE,
      content = function(context)
        -- Get git root directory
        local git_root_output = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")
        if vim.v.shell_error ~= 0 then
          return "Error: Not in a git repository. Please run this command from within a git repository."
        end
        local git_root = git_root_output:gsub("%s+$", "")
        
        -- Run git commands from git root
        local diff_content = vim.fn.system(string.format("cd '%s' && git diff HEAD --no-ext-diff 2>&1", git_root))
        local git_log = vim.fn.system(string.format("cd '%s' && git log -10 --oneline 2>&1", git_root))
        local git_status = vim.fn.system(string.format("cd '%s' && git status --short 2>&1", git_root))
        
        return string.format([[
You are an expert in interpreting code changes according to the Conventional Commits specification and generating high-quality commit messages.

Your task is to analyze the provided `git diff` and generate conventional commit messages. You will propose a structuring the commits: as a single, comprehensive commit

---
### 1. ✍️ Commit Message Format & Rules

You **must** follow these rules precisely.

**a. Structure:**
A commit message consists of a header, body, and footer.

<type>(<scope>): <subject>

[body: explain the 'what' and 'why' of the change]

[footer: reference issues, e.g., 'Closes #123' or list 'BREAKING CHANGE: ...']


**b. Allowed Types:**
You must use one of the following `<type>` values:
- **feat:** A new feature
- **fix:** A bug fix
- **refactor:** A code change that neither fixes a bug nor adds a feature
- **style:** Changes that do not affect the meaning of the code (white-space, formatting, etc.)
- **docs:** Documentation only changes
- **test:** Adding missing tests or correcting existing tests
- **build:** Changes that affect the build system or external dependencies
- **chore:** Other changes that don't modify src or test files
- **ci:** Changes to our CI configuration files and scripts
- **perf:** A code change that improves performance

**c. Style Matching:**
Analyze the `10 latest git commit message` provided as context. Match their tense, style, and `<scope>` conventions to ensure consistency with the repository's history.

If the content is from Zettelkasten note, do not use "zettelkasten" as scope.
The scope must be a short, lowercase identifier that describes the area of the code affected by the change (e.g., `utils`, `api`, `ui`, etc.) base on the specific changes content.

---
### 2. 💡 One-Shot Example

Here is an example of a good response for a given diff.

**Example Input Diff:**
```diff
--- a/README.md
+++ b/README.md
@@ -1,3 +1,4 @@
 # Project
 This is a project.
-Instructions on how to run tests.
+Instructions on how to run tests. See the contributing guide for details.
+
--- a/src/utils.js
+++ b/src/utils.js
@@ -1,3 +1,5 @@
 function helper() {
-  // old implementation
+  // new, better implementation
 }
+
+export { helper };

Example Expected Output:

Markdown block

### Single Commit
Here is a single message for all changes:

- **Message:** `refactor(utils): improve helper function and update docs`

3. 🎯 Expected Output

Return two methods for structuring the commit messages.

- Single Commit:
  - If all changes can be grouped into one logical unit, generate a single, comprehensive commit message.
  - If a body include, wrap your commit text into a markdown block


4. 🧠 Thought Process & Final Review

Before generating the output, think step-by-step:

    Analyze: What was changed and why? What is the primary intent (e.g., new feature, bug fix, refactor)? Is there a consistent pattern across the changed files?
    Group: How can these changes be logically grouped? Can repetitive actions be summarized (e.g., multiple small doc updates = one docs commit)?
    Generate: Create the commit messages according to the format rules.
    Review & Refine: Critically review your own suggestions. Do they accurately reflect the changes? Is the <type> correct? Is the format perfect? Fix any mistakes before providing the final answer.

5. ⚠️ Error Handling & Limitations

    If the provided diff is empty, contains no meaningful changes, or is too ambiguous to interpret, do not generate a commit message. Instead, return a message stating the problem (e.g., "Error: The provided diff is empty or contains no substantive changes.").
    As an AI, you may lack the full business context for these changes. Acknowledge this by appending a brief note if the intent of a change is highly ambiguous.

## 📥 Input Data

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
          git_log,
          git_status,
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
          [[
Generate a commands that can be run to commit.

For example:
```sh
# single commit
git add . && git commit -m "feat(scope): add new feature" 
```
          ]],
        opts = {
          auto_submit = false,
        },
      }
    },
    {
      {
        role = constants.USER_ROLE,
        content =
          [[
Using the @{cmd_runner} to run commands for method single commits.
After finish, run `git log --oneline -n <number-of-commits>` to verify the commits.
          ]],
        opts = {
          auto_submit = false,
        },
      }
    }
  },
}
