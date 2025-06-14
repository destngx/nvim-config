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

Your task is to analyze the provided `git diff` and generate conventional commit messages. You will propose two ways of structuring the commits: as a single, comprehensive commit and as several smaller, logical commits.

---
### 1. ✍️ Commit Message Format & Rules

You **must** follow these rules precisely.

**a. Structure:**
A commit message consists of a header, body, and footer.

&lt;type>(&lt;scope>): &lt;subject>

[optional body: explain the 'what' and 'why' of the change]

[optional footer: reference issues, e.g., 'Closes #123' or list 'BREAKING CHANGE: ...']


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
Markdown

### 1. Multiple Commits
Here is a logical breakdown of the changes into multiple commits:

- **Commit 1:**
  - **Files:** `src/utils.js`
  - **Message:** `refactor(utils): improve helper function implementation`

- **Commit 2:**
  - **Files:** `README.md`
  - **Message:** `docs(readme): link to contributing guide for test info`

### 2. Single Commit
Here is a single message for all changes:

- **Message:** `refactor(utils): improve helper function and update docs`

3. 🎯 Expected Output

Return two methods for structuring the commit messages.

a. Multiple Commits:

    Suggest how the changes can be logically broken down into multiple, atomic commits.
    For each proposed commit, list the associated files and provide a complete commit message.
    Constraint: Each file must belong to only one commit.

b. Single Commit:

    If all changes can be grouped into one logical unit, generate a single, comprehensive commit message.

c. Output Rule:

    If the "Multiple Commits" breakdown results in only one commit, then return only the "Single Commit" section.

d. Optional Format:

    You may return the output as a single JSON object with the keys multipleCommits and singleCommit if it simplifies parsing.

4. 🧠 Thought Process & Final Review

Before generating the output, think step-by-step:

    Analyze: What was changed and why? What is the primary intent (e.g., new feature, bug fix, refactor)? Is there a consistent pattern across the changed files?
    Group: How can these changes be logically grouped? Can repetitive actions be summarized (e.g., multiple small doc updates = one docs commit)?
    Generate: Create the commit messages according to the format rules.
    Review & Refine: Critically review your own suggestions. Do they accurately reflect the changes? Is the <type> correct? Is the format perfect? Fix any mistakes before providing the final answer.

5. ⚠️ Error Handling & Limitations

    If the provided diff is empty, contains no meaningful changes, or is too ambiguous to interpret, do not generate a commit message. Instead, return a message stating the problem (e.g., "Error: The provided diff is empty or contains no substantive changes.").
    As an AI, you may lack the full business context for these changes. Acknowledge this by appending a brief note if the intent of a change is highly ambiguous.Here is the 10 latest git commit message:
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
          [[
Using @cmd_runner to run a single command that using the result of the method multiple commits (if it not available, fallback to single commit method) to stage and commit the files based on the results
After finish, run `git log --oneline <number-of-commits>` to verify the commits.
          ]],
        opts = {
          auto_submit = false,
        },
      }
    }
  },
}
