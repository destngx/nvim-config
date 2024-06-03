-- See: https://github.com/glepnir/galaxyline.nvim
-- Modified by ecosse and destnguyxn

local gl = require('galaxyline')
local condition = require('galaxyline.condition')
-- Configuration {{{1
-- Functions {{{2

local function highlight(group, fg, bg, gui)
  local cmd = string.format('highlight %s guifg=%s guibg=%s', group, fg, bg)

  if gui ~= nil then
    cmd = cmd .. ' gui=' .. gui
  end

  vim.cmd(cmd)
end

-- }}}2

-- Settings {{{2
local lineLengthWarning = 100
local lineLengthError = 120
local leftbracket = ""  -- Empty.
local rightbracket = "" -- Empty.
-- }}}2

gl.short_line_list = { 'NvimTree', 'vista', 'dbui', 'packer', 'tagbar' }
local gls = gl.section

-- Colours, maps and icons {{{2
local colors = {
  bg              = nil,
  modetext        = '#000000',

  giticon         = '#FF8800',
  gitbg           = '#5C2C2E',
  gittext         = '#C5C5C5',

  diagerror       = '#F44747',
  diagwarn        = '#FF8800',
  diaghint        = '#4FC1FF',
  diaginfo        = '#FFCC66',

  lspicon         = '#68AF00',
  lspbg           = '#304B2E',
  lsptext         = '#C5C5C5',

  typeicon        = '#FF8800',
  typebg          = '#5C2C2E',
  typetext        = '#C5C5C5',

  statsicon       = '#9CDCFE',
  statsbg         = '#5080A0',
  statstext       = '#000000',

  lineokfg        = '#000000',
  lineokbg        = '#5080A0',
  linelongerrorfg = '#FF0000',
  linelongwarnfg  = '#FFFF00',
  linelongbg      = '#5080A0',

  shortbg         = '#DCDCAA',
  shorttext       = '#000000',

  shortrightbg    = '#3F3F3F',
  shortrighttext  = '#7C4C4E',

  gpsbg           = '#5C00A3',
  gpstext         = '#C5C5C5',

  red             = '#D16969',
  yellow          = '#DCDCAA',
  magenta         = '#D16D9E',
  green           = '#608B4E',
  orange          = '#FF8800',
  purple          = '#C586C0',
  blue            = '#569CD6',
  cyan            = '#4EC9B0'
}

local mode_map = {
  ['n']        = { '#569CD6', ' NORMAL ' },
  ['i']        = { '#D16969', ' INSERT ' },
  ['R']        = { '#D16969', ' REPLACE ' },
  ['c']        = { '#608B4E', ' COMMAND ' },
  ['v']        = { '#C586C0', ' VISUAL ' },
  ['V']        = { '#C586C0', 'VIS-LN' },
  ['']        = { '#C586C0', 'VIS-BLK' },
  ['s']        = { '#FF8800', ' SELECT ' },
  ['S']        = { '#FF8800', 'SEL-LN' },
  ['']        = { '#DCDCAA', 'SEL-BLK' },
  ['t']        = { '#569CD6', 'TERMINAL' },
  ['Rv']       = { '#D16D69', 'VIR-REP' },
  ['rm']       = { '#FF0000', '- More -' },
  ['r']        = { '#FF0000', "- Hit-Enter -" },
  ['r?']       = { '#FF0000', "- Confirm -" },
  ['cv']       = { '#569CD6', "Vim Ex Mode" },
  ['ce']       = { '#569CD6', "Normal Ex Mode" },
  ['!']        = { '#569CD6', "Shell Running" },
  ['ic']       = { '#DCDCAA', 'Insert mode completion |compl-generic|' },
  ['no']       = { '#DCDCAA', 'Operator-pending' },
  ['nov']      = { '#DCDCAA', 'Operator-pending (forced charwise |o_v|)' },
  ['noV']      = { '#DCDCAA', 'Operator-pending (forced linewise |o_V|)' },
  ['noCTRL-V'] = { '#DCDCAA', 'Operator-pending (forced blockwise |o_CTRL-V|) CTRL-V is one character' },
  ['niI']      = { '#DCDCAA', 'Normal using |i_CTRL-O| in |Insert-mode|' },
  ['niR']      = { '#DCDCAA', 'Normal using |i_CTRL-O| in |Replace-mode|' },
  ['niV']      = { '#DCDCAA', 'Normal using |i_CTRL-O| in |Virtual-Replace-mode|' },
  ['ix']       = { '#DCDCAA', 'Insert mode |i_CTRL-X| completion' },
  ['Rc']       = { '#DCDCAA', 'Replace mode completion |compl-generic|' },
  ['Rx']       = { '#DCDCAA', 'Replace mode |i_CTRL-X| completion' },
}

-- Rag status function {{{2
local function setLineWidthColours()
  local colbg = colors.statsbg
  local linebg = colors.statsbg

  if (vim.fn.col('.') > lineLengthError)
  then
    colbg = colors.linelongerrorfg
  elseif (vim.fn.col('.') > lineLengthWarning)
  then
    colbg = colors.linelongwarnfg
  end

  if (vim.fn.strwidth(vim.fn.getline('.')) > lineLengthError)
  then
    linebg = colors.linelongerrorfg
  elseif (vim.fn.strwidth(vim.fn.getline('.')) > lineLengthWarning)
  then
    linebg = colors.linelongwarnfg
  end

  highlight('LinePosHighlightStart', colbg, colors.statsbg)
  highlight('LinePosHighlightColNum', colors.statstext, colbg)
  highlight('LinePosHighlightMid', linebg, colbg)
  highlight('LineLenHighlightLenNum', colors.statstext, linebg)
  highlight('LinePosHighlightEnd', linebg, colors.statsbg)
end

-- }}}2

-- }}}1

gls.left = {}

gls.right = {}

-- Git info {{{2

-- Git Branch Name {{{3
table.insert(gls.right, {
  GitStart = {
    provider = function() return leftbracket end,
    condition = condition.check_git_workspace,
    highlight = { colors.giticon, colors.bg }
  }
})
table.insert(gls.right, {
  GitIcon = {
    provider = function()
      return ' ' .. DestNgxVim.icons.git
    end,
    condition = condition.check_git_workspace,
    separator = '',
    separator_highlight = { 'NONE', colors.giticon },
    highlight = { colors.gitbg, colors.giticon }
  }
})
table.insert(gls.right, {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = { 'NONE', colors.gitbg },
    highlight = { colors.gittext, colors.gitbg }
  }
})
-- }}}3

-- Git Changes {{{3
table.insert(gls.right, {
  DiffSeparate = {
    provider = function() return '' end,
    separator = ' ',
    separator_highlight = { colors.gittext, colors.gitbg },
  }
})
table.insert(gls.right, {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.check_git_workspace,
    separator = '',
    icon = DestNgxVim.icons.gitAdd,
    highlight = { colors.green, colors.gitbg }
  }
})
table.insert(gls.right, {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.check_git_workspace,
    icon = DestNgxVim.icons.gitChange,
    highlight = { colors.blue, colors.gitbg }
  }
})
table.insert(gls.right, {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.check_git_workspace,
    icon = DestNgxVim.icons.gitRemove,
    highlight = { colors.red, colors.gitbg }
  }
})
table.insert(gls.right, {
  EndGit = {
    provider = function() return rightbracket end,
    condition = condition.check_git_workspace,
    separator = " ",
    separator_highlight = { colors.gitbg, colors.bg },
    highlight = { colors.gitbg, colors.bg }
  }
})
-- }}}3

-- Diagnostics {{{3
table.insert(gls.right, {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = DestNgxVim.icons.errorOutline,
    separator_highlight = { colors.gitbg, colors.bg },
    highlight = { colors.diagerror, colors.bg }
  }
})
table.insert(gls.right, {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = DestNgxVim.icons.warningTriangleNoBg,
    highlight = { colors.diagwarn, colors.bg }
  }
})
table.insert(gls.right, {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = DestNgxVim.icons.lightbulbOutline,
    highlight = { colors.diaghint, colors.bg }
  }
})
table.insert(gls.right, {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = DestNgxVim.icons.infoOutline,
    highlight = { colors.diaginfo, colors.bg }
  }
})
-- Right {{{1


-- Type {{{2
table.insert(gls.left, {
  FileIcon = {
    provider = 'FileIcon',
    highlight = { colors.typeicon, "NONE" }
  }
})
if DestNgxVim.statusline.path_enabled then
  table.insert(gls.left, {
    FileName = {
      provider = function()
        if #vim.fn.expand '%:p' == 0 then
          return ''
        end

        if DestNgxVim.statusline.path_type == 'relative' then
          local fname = vim.fn.expand('%:p')
          return fname:gsub(vim.fn.getcwd() .. '/', '') .. ' '
        end

        return vim.fn.expand '%:t'
      end,
    }
  })
end

-- Cursor Position Section {{{2
table.insert(gls.right, {
  StatsSectionStart = {
    provider = function() return leftbracket end,
    highlight = { colors.statsicon, colors.bg }
  }
})

table.insert(gls.right, {
  StatsMid = {
    provider = function() return rightbracket .. ' ' end,
    highlight = { colors.statsicon, colors.statsbg }
  }
})
table.insert(gls.right, {
  VerticalPosAndSize = {
    provider = function()
      return string.format("%s:%3i ", vim.fn.line('.'), vim.fn.line('$'))
    end,
    separator = DestNgxVim.icons.constant,
    separator_highlight = { colors.statsicon, colors.statsbg },
    highlight = { colors.statstext, colors.statsbg }
  }
})
if vim.bo.filetype ~= "markdown" then
  table.insert(gls.right, {
    LineLengthIcon = {
      provider = function() return '' end,
      separator = DestNgxVim.icons.word,
      separator_highlight = { colors.statsicon, colors.statsbg },
    }
  })
  table.insert(gls.right, {
    CursorColumn = {
      provider = function()
        setLineWidthColours()
        local currentCol = vim.fn.col('.')
        if (currentCol > 9) then
          return string.format("%2i", currentCol) .. ":"
        end
        if (currentCol > 99) then
          return string.format("%3i", currentCol) .. ":"
        end
        return string.format("%i", currentCol) .. ":"
      end,
      highlight = 'LinePosHighlightColNum'
    }
  })
  table.insert(gls.right, {
    LineLength = {
      provider = function()
        local currentLine = string.len(vim.fn.getline('.'))
        if (currentLine > 9) then
          return string.format("%2i", currentLine) .. ' '
        end
        if (currentLine > 99) then
          return string.format("%3i", currentLine) .. ' '
        end
        return string.format("%i", currentLine) .. ' '
      end,
      highlight = 'LineLenHighlightLenNum'
    }
  })
else
  table.insert(gls.right, {
    LineLengthIcon = {
      provider = function() return '' end,
      separator = DestNgxVim.icons.word,
      separator_highlight = { colors.statsicon, colors.statsbg },
    }
  })
  table.insert(gls.right, {
    CursorColumn = {
      provider = function()
        setLineWidthColours()
        local currentCol = vim.fn.col('.')
        if (currentCol > 9) then
          return string.format("%2i", currentCol) .. ":"
        end
        if (currentCol > 99) then
          return string.format("%3i", currentCol) .. ":"
        end
        return string.format("%i", currentCol) .. ":"
      end,
    }
  })
  table.insert(gls.right, {
    LineLength = {
      provider = function()
        local currentLine = string.len(vim.fn.getline('.'))
        if (currentLine > 9) then
          return string.format("%2i", currentLine) .. ' '
        end
        if (currentLine > 99) then
          return string.format("%3i", currentLine) .. ' '
        end
        return string.format("%i", currentLine) .. ' '
      end,
    }
  })
end
table.insert(gls.right, {
  LineLengthEnd = {
    provider = function()
      return "" .. rightbracket .. ""
    end,
    highlight = 'LinePosHighlightEnd'
  }
})
table.insert(gls.right, {
  WordCountIcon = {
    provider = function()
      return DestNgxVim.icons.keyword
    end,
    condition = condition.hide_in_width,
    highlight = { colors.statsicon, colors.statsbg }
  }
})
table.insert(gls.right, {
  WordCount = {
    provider = function()
      setLineWidthColours()
      return string.format("%i", vim.fn.wordcount().words)
    end,
    highlight = { colors.shorttext, colors.statsbg }
  }
})
table.insert(gls.right, {
  TabstopIcon = {
    provider = function()
      if vim.bo.expandtab
      then
        return DestNgxVim.icons.fillBox
      else
        return DestNgxVim.icons.outlineBox
      end
    end,
    condition = condition.hide_in_width,
    highlight = { colors.statsicon, colors.statsbg }
  }
})
table.insert(gls.right, {
  Tabstop = {
    provider = function()
      return tostring(vim.bo.shiftwidth) .. " "
    end,
    condition = condition.hide_in_width,
    highlight = { colors.shorttext, colors.statsbg }
  }
})


-- Vi mode {{{2
table.insert(gls.right, {
  ViModeSpaceOnFarLeft = {
    provider = function() return " " end,
    highlight = { colors.giticon, colors.bg }
  }
})
table.insert(gls.right, {
  ViModeLeft = {
    provider = function()
      highlight('ViModeHighlight', mode_map[vim.fn.mode()][1], colors.bg)
      return ""
    end,
    highlight = 'ViModeHighlight'
  }
})
table.insert(gls.right, {
  ViModeIconAndText = {
    provider = function()
      highlight('GalaxyViMode', colors.modetext, mode_map[vim.fn.mode()][1])
      return " " .. mode_map[vim.fn.mode()][2]
    end,
    highlight = 'GalaxyViMode'
  }
})

-- Left Short {{{1
gls.short_line_left = {}

table.insert(gls.short_line_left, {
  ShortSectionStart = {
    provider = function() return leftbracket end,
    highlight = { colors.shortbg, colors.bg }
  }
})
table.insert(gls.short_line_left, {
  ShortSectionSpace = {
    provider = function() return " " end, highlight = { colors.shorttext, colors.shortbg }
  }
})

table.insert(gls.short_line_left, {
  ShortSectionMid = {
    provider = function() return " " end,
    highlight = { colors.shortbg, colors.shortbg }
  }
})

table.insert(gls.short_line_left, {
  ShortSectionEnd = {
    provider = function() return rightbracket end,
    highlight = { colors.shortbg, colors.bg }
  }
})
-- }}}1

-- Right Short {{{1
gls.short_line_right = {}

table.insert(gls.short_line_right, {
  BufferIcon = {
    provider = 'BufferIcon',
    separator_highlight = { colors.shorttext, colors.bg },
    highlight = { colors.shortrighttext, colors.bg }
  }
})
-- }}}1
