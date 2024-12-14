return {
  'rasulomaroff/reactive.nvim',
  event = 'BufReadPre',
  config = function()
    require('reactive').setup {
      builtin = {
        cursorline = true,
        cursor = true,
        modemsg = true
      }
    }
  end
}
