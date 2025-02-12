return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  enabled = DestNgxVim.plugins.experimental_cursor.enabled,
  opts = {
    -- Cursor color. Defaults to Cursor gui color
    cursor_color = "#d3cdc3",

    -- Background color. Defaults to Normal gui background color
    normal_bg = "#282828",

    -- Smear cursor when switching buffers
    smear_between_buffers = false,

    -- Smear cursor when moving within line or to neighbor lines
    smear_between_neighbor_lines = true,

    -- Use floating windows to display smears outside buffers.
    -- May have performance issues with other plugins.
    use_floating_windows = false,

    -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
    -- Smears will blend better on all backgrounds.
    legacy_computing_symbols_support = true,
    -- How fast the smear's head moves towards the target.
    -- 0: no movement, 1: instantaneous, default: 0.6
    stiffness = 0.6,

    -- How fast the smear's tail moves towards the head.
    -- 0: no movement, 1: instantaneous, default: 0.3
    trailing_stiffness = 0.5,

    -- How much the tail slows down when getting close to the head.
    -- 0: no slowdown, more: more slowdown, default: 0.1
    trailing_exponent = 0,

    -- Stop animating when the smear's tail is within this distance (in characters) from the target.
    -- Default: 0.1
    distance_stop_animating = 0.1,

    -- Attempt to hide the real cursor when smearing.
    -- Default: true
    hide_target_hack = true,
  },
}
