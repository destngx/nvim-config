local icons = require("utils.icons")

return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          { desc = icons.update .. 'Update',
            group = '@property',
            action = 'Lazy update',
            key = 'u'
          },
          {
            desc = icons.fileNoBg .. 'Files',
            group = 'Label',
            action = 'FzfLua files',
            key = 'f',
          },
          {
            desc = icons.word .. 'Find Word',
            group = 'DiagnosticHint',
            action = 'FzfLua live_grep',
            key = 'w',
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
