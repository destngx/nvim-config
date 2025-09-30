# AGENTS.md
1. Purpose: Neovim config repo (Lua focus) – automate edits safely; avoid breaking user-specific paths.
2. Build/Run: `nvim +Lazy! sync +qa` to install/update; `:checkhealth` for diagnostics; no conventional test suite.
3. Lint (external tools): JS/TS/React/Vue via `eslint_d`; Python via `pylint`; Shell via `shellcheck`; Docker via `hadolint`; Terraform via `tflint`/`terraform_fmt`; SQL via `sqlfluff`; Markdown via `markdownlint-cli2` & `vale`.
4. Formatting: Prefer `biome` if `biome.json(c)` present else `prettier` (various *.prettierrc* forms). Terraform always `terraform_fmt`. Markdown: `markdown-toc` then `markdownlint-cli2`.
5. Commands (editor): Use `:Format` (range-aware) for buffer; `:lua vim.lsp.buf.format()` fallback acceptable.
6. Single-file JS/TS check: run `eslint_d <file>` (ensure root has eslint config or `eslintConfig` in package.json).
7. Style (Lua): snake_case for funcs/vars; PascalCase modules; CONSTANTS_UPPER; prefix private with `_`; heavy use of `local`; avoid globals (Cursor rule).
8. Imports/Modules: Use `require("module.path")`; group std libs, then third-party, then local (`utils.*`, `plugins.*`). No trailing semicolons.
9. Indentation & spacing: 2 spaces; expandtab; no tabs; keep lines concise; remove redundant whitespace.
10. Error handling: Prefer protected calls `pcall`/`xpcall`; use `assert` for invariants; explicit nil checks; surface user-facing issues with `vim.notify` (as seen in linter/formatter installers).
11. Performance: Localize frequently used globals; precompute tables; avoid creating tables in hot loops; use `table.concat` for strings.
12. Naming: Descriptive yet brief; avoid ambiguous one-letter names; consistent suffixes (e.g., *_ok for pcall success flags).
13. Git etiquette: Small, focused commits; commit message explains "why"; do NOT commit secrets, generated lockfiles beyond `lazy-lock.json` unless intentionally updated.
14. AI / Tools: Honor Cursor Lua rules (clarity, modularity, security, testing mindset) even though formal tests absent.
15. Adding Plugins: Register in proper category dir; keep config minimal & in a dedicated file; lazy-load when possible.
16. New Commands: Provide user commands via `vim.api.nvim_create_user_command`; ensure safe defaults & async where possible.
17. Markdown: Keep tables/headings tidy; update TOC via formatter chain; prefer backticks for identifiers.
18. Terraform/HCL: Always run `terraform fmt` (or via conform) before commit; validate with `tflint` if present.
19. Python: Follow PEP8 (indent 4 spaces if editing python files, though editor base is 2 for Lua); prefer explicit imports.
20. Security: Never execute arbitrary `loadstring` on external input; validate paths; avoid writing outside repo root.
