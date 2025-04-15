return {
  'rasulomaroff/reactive.nvim',
  event = 'BufEnter',
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
