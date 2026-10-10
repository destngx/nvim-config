-- ╭──────────────────────────────────────────────────────────╮
-- │ Git worktree support                                     │
-- │ List / switch / create / delete worktrees via fzf-lua.   │
-- │ Switching remaps open buffers into the target worktree,  │
-- │ drops stale ones and stops orphaned LSP clients.         │
-- │ Emits `User WorktreeSwitch` with { prev_root, root }.    │
-- ╰──────────────────────────────────────────────────────────╯
local M = {}

local api = vim.api
local uv = vim.uv
local TITLE = "Worktree"
local SUBCOMMANDS = { "list", "switch", "create", "delete" }

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = TITLE })
end

local function realpath(path)
  return uv.fs_realpath(path) or vim.fs.normalize(path)
end

--- Path of `path` relative to `root`, "" when equal, nil when outside.
local function relative_to(path, root)
  if path == root then
    return ""
  end
  local prefix = root .. "/"
  if path:sub(1, #prefix) == prefix then
    return path:sub(#prefix + 1)
  end
end

--- Run git synchronously. Returns ok, stdout lines, stderr.
local function git(args, cwd)
  local cmd = vim.list_extend({ "git" }, args)
  local ok, res = pcall(function()
    return vim.system(cmd, { cwd = cwd or uv.cwd(), text = true }):wait()
  end)
  if not ok then
    return false, {}, tostring(res)
  end
  local lines = vim.split(vim.trim(res.stdout or ""), "\n", { trimempty = true })
  return res.code == 0, lines, vim.trim(res.stderr or "")
end

--- Run git asynchronously; `on_done(ok, stderr)` runs on the main loop.
local function git_async(args, on_done)
  local cmd = vim.list_extend({ "git" }, args)
  vim.system(cmd, { cwd = uv.cwd(), text = true }, function(res)
    vim.schedule(function()
      on_done(res.code == 0, vim.trim(res.stderr or ""))
    end)
  end)
end

local function in_git_repo()
  local ok = git({ "rev-parse", "--git-dir" })
  if not ok then
    notify("Not inside a git repository", vim.log.levels.WARN)
  end
  return ok
end

--- Toplevel of the worktree containing cwd (nil inside a bare repo).
local function current_root()
  local ok, out = git({ "rev-parse", "--show-toplevel" })
  if ok and out[1] then
    return realpath(out[1])
  end
end

---@class Worktree
---@field path string
---@field head string?
---@field branch string?
---@field bare boolean
---@field detached boolean
---@field locked boolean
---@field prunable boolean
---@field main boolean

--- Parse `git worktree list --porcelain`. The first entry is the main worktree.
---@return Worktree[]
function M.list()
  local ok, lines, err = git({ "worktree", "list", "--porcelain" })
  if not ok then
    notify("git worktree list failed: " .. err, vim.log.levels.ERROR)
    return {}
  end

  local worktrees, wt = {}, nil
  for _, line in ipairs(lines) do
    local key, value = line:match("^(%S+)%s?(.*)$")
    if key == "worktree" then
      wt = {
        path = realpath(value),
        bare = false,
        detached = false,
        locked = false,
        prunable = false,
        main = #worktrees == 0,
      }
      worktrees[#worktrees + 1] = wt
    elseif wt and key == "HEAD" then
      wt.head = value
    elseif wt and key == "branch" then
      wt.branch = value:gsub("^refs/heads/", "")
    elseif wt and (key == "bare" or key == "detached" or key == "locked" or key == "prunable") then
      wt[key] = true
    end
  end
  return worktrees
end

local function find_worktree(path)
  local target = realpath(path)
  for _, wt in ipairs(M.list()) do
    if wt.path == target then
      return wt
    end
  end
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ Switch                                                   │
-- ╰──────────────────────────────────────────────────────────╯

--- Open the counterpart of every file buffer under `prev_root` inside
--- `new_root`, point windows at them and delete the stale buffers.
local function remap_buffers(prev_root, new_root)
  local mapped, stale = {}, {}
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "" and vim.bo[buf].buflisted then
      local name = api.nvim_buf_get_name(buf)
      local rel = name ~= "" and relative_to(realpath(name), prev_root)
      if rel then
        stale[buf] = true
        local target = vim.fs.joinpath(new_root, rel)
        if rel ~= "" and uv.fs_stat(target) then
          local new_buf = vim.fn.bufadd(target)
          vim.bo[new_buf].buflisted = true
          mapped[buf] = new_buf
        end
      end
    end
  end

  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    if stale[buf] and api.nvim_win_get_config(win).relative == "" then
      local cursor = api.nvim_win_get_cursor(win)
      api.nvim_win_call(win, function()
        if mapped[buf] then
          vim.cmd("keepjumps buffer " .. mapped[buf])
          pcall(api.nvim_win_set_cursor, win, cursor)
        else
          vim.cmd("keepjumps edit " .. vim.fn.fnameescape(new_root))
        end
      end)
    end
  end

  local kept = 0
  for buf in pairs(stale) do
    if vim.bo[buf].modified then
      kept = kept + 1
    else
      pcall(api.nvim_buf_delete, buf, {})
    end
  end
  if kept > 0 then
    notify(("Kept %d modified buffer(s) from the previous worktree"):format(kept), vim.log.levels.WARN)
  end
end

--- Stop LSP clients rooted in `root` that no longer serve any buffer.
local function stop_orphan_clients(root)
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.root_dir and relative_to(realpath(client.root_dir), root)
        and vim.tbl_isempty(client.attached_buffers) then
      client:stop()
    end
  end
end

---@param path string worktree path
function M.switch(path)
  if not in_git_repo() then
    return
  end
  local new_root = realpath(vim.fn.fnamemodify(path, ":p"))
  if not uv.fs_stat(new_root) then
    notify("Worktree does not exist: " .. new_root, vim.log.levels.ERROR)
    return
  end

  local prev_root = current_root()
  if prev_root == new_root then
    notify("Already in " .. new_root)
    return
  end

  -- Keep the same sub-directory as cwd when it exists in the target.
  local new_cwd = new_root
  local rel_cwd = prev_root and relative_to(realpath(uv.cwd()), prev_root)
  if rel_cwd and rel_cwd ~= "" and vim.fn.isdirectory(vim.fs.joinpath(new_root, rel_cwd)) == 1 then
    new_cwd = vim.fs.joinpath(new_root, rel_cwd)
  end

  vim.cmd.cd(vim.fn.fnameescape(new_cwd))
  if prev_root then
    remap_buffers(prev_root, new_root)
    vim.schedule(function()
      stop_orphan_clients(prev_root)
    end)
  end
  vim.cmd("clearjumps")

  api.nvim_exec_autocmds("User", {
    pattern = "WorktreeSwitch",
    data = { prev_root = prev_root, root = new_root },
  })
  notify("Switched to " .. vim.fn.fnamemodify(new_root, ":~"))
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ Create                                                   │
-- ╰──────────────────────────────────────────────────────────╯

--- Default location: inside the bare repo, otherwise `<repo>.worktrees/<branch>`
--- next to the main worktree so siblings stay grouped and out of the repo.
local function default_path(branch)
  local main = M.list()[1]
  if not main then
    return ""
  end
  local slug = branch:gsub("[/\\:%s]+", "-")
  if main.bare then
    return vim.fs.joinpath(main.path, slug)
  end
  return vim.fs.joinpath(vim.fs.dirname(main.path), vim.fs.basename(main.path) .. ".worktrees", slug)
end

--- Remote-tracking ref for `branch` (prefers origin), e.g. "origin/feat".
local function find_remote_ref(branch)
  local ok, refs = git({ "for-each-ref", "--format=%(refname:short)", "refs/remotes/*/" .. branch })
  if not ok or #refs == 0 then
    return nil
  end
  for _, ref in ipairs(refs) do
    if ref == "origin/" .. branch then
      return ref
    end
  end
  return refs[1]
end

--- Build `git worktree add` args: reuse a local branch, track a remote one,
--- or create a new branch from the current HEAD.
local function add_args(branch, path)
  if git({ "show-ref", "--verify", "--quiet", "refs/heads/" .. branch }) then
    return { "worktree", "add", path, branch }
  end
  local remote_ref = find_remote_ref(branch)
  if remote_ref then
    return { "worktree", "add", "--track", "-b", branch, path, remote_ref }
  end
  return { "worktree", "add", "-b", branch, path }
end

---@param branch string?
---@param path string?
function M.create(branch, path)
  if not in_git_repo() then
    return
  end
  if not branch or branch == "" then
    return M.pick_branch()
  end
  if not git({ "check-ref-format", "--branch", branch }) then
    notify("Invalid branch name: " .. branch, vim.log.levels.ERROR)
    return
  end

  local function run(target)
    if not target or vim.trim(target) == "" then
      return
    end
    target = vim.fn.fnamemodify(vim.fn.expand(vim.trim(target)), ":p"):gsub("/$", "")
    notify(("Creating worktree for '%s'..."):format(branch))
    git_async(add_args(branch, target), function(ok, err)
      if not ok then
        notify("git worktree add failed:\n" .. err, vim.log.levels.ERROR)
        return
      end
      M.switch(target)
    end)
  end

  if path and path ~= "" then
    return run(path)
  end
  vim.ui.input({ prompt = "Worktree path: ", default = default_path(branch), completion = "dir" }, run)
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ Delete                                                   │
-- ╰──────────────────────────────────────────────────────────╯

local function wipe_buffers_under(root)
  for _, buf in ipairs(api.nvim_list_bufs()) do
    local name = api.nvim_buf_get_name(buf)
    if name ~= "" and relative_to(realpath(name), root) and not vim.bo[buf].modified then
      pcall(api.nvim_buf_delete, buf, { force = true })
    end
  end
  vim.schedule(function()
    stop_orphan_clients(root)
  end)
end

local function offer_branch_delete(branch)
  if not branch then
    return
  end
  if vim.fn.confirm(("Also delete branch '%s'?"):format(branch), "&Yes\n&No", 2) ~= 1 then
    return
  end
  local ok, _, err = git({ "branch", "-d", branch })
  if ok then
    notify(("Deleted branch '%s'"):format(branch))
    return
  end
  local prompt = ("Branch '%s' is not fully merged:\n%s\nForce delete it?"):format(branch, err)
  if vim.fn.confirm(prompt, "&Yes\n&No", 2) == 1 then
    ok, _, err = git({ "branch", "-D", branch })
    notify(ok and ("Deleted branch '%s'"):format(branch) or err, ok and vim.log.levels.INFO or vim.log.levels.ERROR)
  end
end

---@param path string worktree path
function M.delete(path)
  if not in_git_repo() then
    return
  end
  local wt = find_worktree(path)
  if not wt then
    notify("Not a worktree: " .. path, vim.log.levels.ERROR)
    return
  end
  if wt.main or wt.bare then
    notify("Refusing to delete the main worktree", vim.log.levels.WARN)
    return
  end
  if wt.path == current_root() then
    notify("Cannot delete the current worktree, switch away first", vim.log.levels.WARN)
    return
  end
  local display = vim.fn.fnamemodify(wt.path, ":~")
  if vim.fn.confirm("Remove worktree " .. display .. "?", "&Yes\n&No", 2) ~= 1 then
    return
  end

  local function on_removed()
    wipe_buffers_under(wt.path)
    notify("Removed " .. display)
    offer_branch_delete(wt.branch)
  end

  git_async({ "worktree", "remove", wt.path }, function(ok, err)
    if ok then
      return on_removed()
    end
    local prompt = ("Could not remove %s:\n%s\nForce remove (discards changes)?"):format(display, err)
    if vim.fn.confirm(prompt, "&Yes\n&No", 2) ~= 1 then
      return
    end
    git_async({ "worktree", "remove", "--force", wt.path }, function(force_ok, force_err)
      if force_ok then
        return on_removed()
      end
      notify("git worktree remove failed:\n" .. force_err, vim.log.levels.ERROR)
    end)
  end)
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ Pickers                                                  │
-- ╰──────────────────────────────────────────────────────────╯

local function path_from_line(line)
  return line and line:match("\t(.+)$")
end

---@param opts { action: "switch"|"delete" }?
function M.pick(opts)
  opts = opts or {}
  if not in_git_repo() then
    return
  end
  local fzf_ok, fzf = pcall(require, "fzf-lua")
  if not fzf_ok then
    notify("fzf-lua is required for the worktree picker", vim.log.levels.ERROR)
    return
  end
  local ansi = require("fzf-lua.utils").ansi_codes

  local root = current_root()
  local worktrees = vim.tbl_filter(function(wt)
    return not wt.bare
  end, M.list())

  local width = 0
  local labels = {}
  for i, wt in ipairs(worktrees) do
    local label = wt.branch or ("(detached " .. (wt.head or ""):sub(1, 7) .. ")")
    if wt.locked then label = label .. " [locked]" end
    if wt.prunable then label = label .. " [prunable]" end
    labels[i] = label
    width = math.max(width, #label)
  end

  local lines = {}
  for i, wt in ipairs(worktrees) do
    local marker = wt.path == root and ansi.green("●") or " "
    local label = labels[i] .. string.rep(" ", width - #labels[i])
    lines[i] = ("%s %s\t%s"):format(marker, wt.main and ansi.yellow(label) or label, wt.path)
  end

  local function with_path(fn)
    return function(selected)
      local path = path_from_line(selected[1])
      if path then
        fn(path)
      end
    end
  end

  local delete_mode = opts.action == "delete"
  fzf.fzf_exec(lines, {
    prompt = "Worktrees> ",
    winopts = { title = delete_mode and " Delete worktree " or " Worktrees " },
    header = delete_mode and "enter: delete" or "enter: switch | alt-d: delete | alt-n: new",
    fzf_opts = { ["--delimiter"] = "\t", ["--no-multi"] = true },
    preview = "git -C {2} -c color.status=always status --short --branch"
        .. " && echo && git -C {2} log --oneline --decorate --color=always -n 50",
    actions = {
      ["default"] = with_path(delete_mode and M.delete or M.switch),
      ["alt-d"] = with_path(M.delete),
      ["alt-n"] = function() M.pick_branch() end,
    },
  })
end

--- Pick a local/remote branch to create a worktree for. Enter with no match,
--- or alt-n, creates a new branch named after the query.
function M.pick_branch()
  if not in_git_repo() then
    return
  end
  local fzf_ok, fzf = pcall(require, "fzf-lua")
  if not fzf_ok then
    return vim.ui.input({ prompt = "Branch: " }, function(branch) M.create(branch) end)
  end

  local checked_out = {}
  for _, wt in ipairs(M.list()) do
    if wt.branch then
      checked_out[wt.branch] = true
    end
  end

  local _, refs = git({ "for-each-ref", "--sort=-committerdate", "--format=%(refname)", "refs/heads", "refs/remotes" })
  local lines, branch_of = {}, {}
  for _, ref in ipairs(refs) do
    local short, branch = ref:match("^refs/heads/(.+)$"), nil
    if short then
      branch = short
    else
      short = ref:match("^refs/remotes/(.+)$")
      branch = short and not short:match("/HEAD$") and short:match("^[^/]+/(.+)$")
    end
    if branch and not checked_out[branch] and not branch_of[short] then
      branch_of[short] = branch
      lines[#lines + 1] = short
    end
  end

  local function create_new(_, fzf_opts)
    vim.ui.input({ prompt = "New branch: ", default = fzf_opts and fzf_opts.last_query or "" }, function(branch)
      if branch and vim.trim(branch) ~= "" then
        M.create(vim.trim(branch))
      end
    end)
  end

  fzf.fzf_exec(lines, {
    prompt = "Branch> ",
    winopts = { title = " New worktree " },
    header = "enter: use branch | alt-n: new branch from query",
    fzf_opts = { ["--no-multi"] = true },
    preview = "git log --oneline --decorate --color=always -n 50 {}",
    actions = {
      ["default"] = function(selected, fzf_opts)
        local branch = selected[1] and branch_of[selected[1]]
        if branch then
          M.create(branch)
        else
          create_new(selected, fzf_opts)
        end
      end,
      ["alt-n"] = create_new,
    },
  })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ Command & keymaps                                        │
-- ╰──────────────────────────────────────────────────────────╯

local function complete(arglead, cmdline)
  local args = vim.split(cmdline, "%s+", { trimempty = true })
  local nargs = #args + (cmdline:match("%s$") and 1 or 0)
  local candidates = {}
  if nargs <= 2 then
    candidates = SUBCOMMANDS
  elseif nargs == 3 and (args[2] == "switch" or args[2] == "delete") then
    candidates = vim.tbl_map(function(wt) return wt.path end, M.list())
  elseif nargs == 3 and args[2] == "create" then
    local _, branches = git({ "for-each-ref", "--format=%(refname:short)", "refs/heads" })
    candidates = branches
  elseif nargs == 4 and args[2] == "create" then
    return vim.fn.getcompletion(arglead, "dir")
  end
  return vim.tbl_filter(function(item)
    return vim.startswith(item, arglead)
  end, candidates)
end

local function command(cmd)
  local sub, arg1, arg2 = cmd.fargs[1], cmd.fargs[2], cmd.fargs[3]
  if not sub or sub == "list" then
    M.pick()
  elseif sub == "switch" then
    if arg1 then M.switch(arg1) else M.pick() end
  elseif sub == "create" then
    M.create(arg1, arg2)
  elseif sub == "delete" then
    if arg1 then M.delete(arg1) else M.pick({ action = "delete" }) end
  else
    notify("Unknown subcommand: " .. sub, vim.log.levels.ERROR)
  end
end

function M.setup()
  api.nvim_create_user_command("Worktree", command, {
    nargs = "*",
    complete = complete,
    desc = "Git worktree: list | switch [path] | create [branch] [path] | delete [path]",
  })

  local keymap = vim.keymap.set
  keymap("n", "<leader>gww", M.pick, { desc = "List/switch worktrees", silent = true })
  keymap("n", "<leader>gwc", M.pick_branch, { desc = "Create worktree", silent = true })
  keymap("n", "<leader>gwd", function() M.pick({ action = "delete" }) end, { desc = "Delete worktree", silent = true })
end

return M
