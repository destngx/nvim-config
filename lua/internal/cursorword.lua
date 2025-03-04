local function highlight_cursorword()
  if vim.g.cursorword_highlight ~= false then
    vim.cmd('highlight CursorWord term=underline cterm=underline gui=underline')
  end
end

local function disable_cursorword()
  local disable_ft = {
    ['alpha'] = true,
    ['lspsagafinder'] = true,
    ['NeogitStatus'] = true,
    ['text'] = true,
  }
  if not disable_ft[vim.bo.ft] then
    return
  end
  if vim.w.cursorword_id ~= 0 and vim.w.cursorword_id ~= nil and vim.w.cursorword_match ~= 0 then
    vim.fn.matchdelete(vim.w.cursorword_id)
    vim.w.cursorword_id = nil
    vim.w.cursorword_match = nil
    vim.w.cursorword = nil
  end
end

local function matchadd()
  local disable_ft = {
    ['alpha'] = true,
    ['neo-tree'] = true,
    ['lspsagafinder'] = true,
    ['dashboard'] = true,
    ['checkhealth'] = true,
  }
  if disable_ft[vim.bo.ft] then
    return
  end
  local fname_ext = string.lower(vim.fn.expand('%:e'))
  local disable_file_ext = {
    ['ico'] = true,
    ['png'] = true,
    ['jpeg'] = true,
    ['jpg'] = true,
    ['epub'] = true,
    ['pptx'] = true,
    ['xlsx'] = true,
  }
  if disable_file_ext[fname_ext] then
    return
  end
  if vim.api.nvim_get_mode().mode == 'i' then
    return
  end

  local column = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local cursorword = vim.fn.matchstr(line:sub(1, column + 1), [[\k*$]])
      .. vim.fn.matchstr(line:sub(column + 1), [[^\k*]]):sub(2)

  if cursorword == vim.w.cursorword then
    return
  end
  vim.w.cursorword = cursorword
  if vim.w.cursorword_match == 1 then
    vim.call('matchdelete', vim.w.cursorword_id)
  end
  vim.w.cursorword_match = 0
  if cursorword == ''
      or #cursorword > 100
      or #cursorword < 3
      or string.find(cursorword, '[\192-\255]+') ~= nil
  then
    return
  end
  local pattern = [[\<]] .. cursorword .. [[\>]]
  vim.w.cursorword_id = vim.fn.matchadd('CursorWord', pattern, -1)
  vim.w.cursorword_match = 1
end

local function cursor_moved()
  if vim.api.nvim_get_mode().mode == 'n' then
    matchadd()
  end
end

highlight_cursorword()

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  pattern = '*',
  callback = cursor_moved,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'BufWinEnter' }, {
  pattern = '*',
  callback = disable_cursorword,
})
