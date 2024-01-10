require('obsidian').setup({
  workspaces = {
    {
      name = "Persona",
      path = "~/projects/obsidian-vaults/Persona",
    },
  },
  notes_subdir = "Zettelkasten",
  completion = {
    nvim_cmp = true,
    min_chars = 2,
    new_notes_location = "notes_subdir",
  },
  templates = {
    subdir = "Templates",
    date_format = "%d-%m-%Y",
    time_format = "%H:%m",
  },
  attachments = { img_folder = "Zettelkasten/Attachments" },
  -- finder_mappings = {
  --   -- Create a new note from your query with `:ObsidianSearch` and `:ObsidianQuickSwitch`.
  --   -- Currently only telescope supports this.
  --   new = "<C-x>",
  -- },
  mappings = {
    -- Overrides the 'gd' mapping to work on markdown/wiki links within your vault.
    ["gd"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    -- Toggle check-boxes.
    ["<leader>oc"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
    },

    -- ["<leader>on"] = {
    --   action = function()
    --     return "<expr>:ObsidianNew " .. vim.fn.input('file name: ') .. "<cr>"
    --   end,
    --   opts = { expr = true, buffer = false },
    -- },
    -- ["<leader>or"] = {
    --   action = function()
    --     return ":ObsidianRename " .. vim.fn.input('file name: ') .. "<cr>"
    --   end,
    --   opts = { expr = true, buffer = true },
    -- },
  },
  disable_frontmatter = false,
  note_frontmatter_func = function(note)
    -- This is equivalent to the default frontmatter function.
    local out = { tags = note.tags }
    -- `note.metadata` contains any manually added fields in the frontmatter.
    -- So here we just make sure those fields are kept in the frontmatter.
    if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
      for k, v in pairs(note.metadata) do
        out[k] = v
      end
    end
    return out
  end,
})
