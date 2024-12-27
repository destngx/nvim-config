local icons = DestNgxVim.icons
-- local function capture(cmd, raw)
-- 	local f = assert(io.popen(cmd, "r"))
-- 	local s = assert(f:read("*a"))
-- 	f:close()
-- 	if raw then
-- 		return s
-- 	end
-- 	s = string.gsub(s, "^%s+", "")
-- 	s = string.gsub(s, "%s+$", "")
-- 	s = string.gsub(s, "[\n\r]+", " ")
-- 	return s
-- end
-- local function split(source, sep)
-- 	local result, i = {}, 1
-- 	while true do
-- 		local a, b = source:find(sep)
-- 		if not a then
-- 			break
-- 		end
-- 		local candidat = source:sub(1, a - 1)
-- 		if candidat ~= "" then
-- 			result[i] = candidat
-- 		end
-- 		i = i + 1
-- 		source = source:sub(b + 1)
-- 	end
-- 	if source ~= "" then
-- 		result[i] = source
-- 	end
-- 	return result
-- end
-- if vim.fn.executable("onefetch") == 1 then
-- local header = split(
--   capture(
--     [[onefetch 2>/dev/null | sed 's/\x1B[@A-Z\\\]^_]\|\x1B\[[0-9:;<=>?]*[-!"#$%&'"'"'()*+,.\/]*[][\\@A-Z^_`a-z{|}~]//g']],
--     true
--   ),
--   "\n"
-- )
-- if next(header) ~= nil then
--   require("alpha.themes.dashboard").section.header.val = header
--   require("alpha").redraw()
-- end
-- end

return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        week_header = {
          enable = true,
          -- append = header,
        },
        shortcut = {
          { desc = icons.update .. 'Plugins',
            group = '@property',
            action = 'Lazy',
            key = 'l'
          },
          {
            desc = icons.fileNoBg .. 'Files',
            group = 'Label',
            action = 'FzfLua files',
            key = '<C-p>',
          },
          {
            desc = icons.word .. 'Find Word',
            group = 'DiagnosticHint',
            action = 'FzfLua live_grep',
            key = '<S-p>',
          },
          {
            desc = icons.exit .. 'Quit',
            group = 'DiagnosticError',
            action = 'quitall',
            key = 'q',
          },
        },
        project = {
          action = 'FzfLua files cwd=',
          limit = 4,
        },
        mru = {
          limit = 4,
        },
      },
    }
  end,
  dependencies = { { "echasnovski/mini.icons" } }
}
