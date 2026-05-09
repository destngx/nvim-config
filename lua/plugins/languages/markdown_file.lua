return {
  {
    "OXY2DEV/markview.nvim",
    ft = { "codecompanion" },
    opts = {
      preview = {
        filetypes = { "codecompanion" },
        ignore_buftypes = {},
      },
    },
  },
  {
    "vhyrro/luarocks.nvim",
    -- enabled = os.getenv "IS_WSL" ~= "true",
    enabled = false,
    lazy = false,
    priority = 1001, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    enabled = false,
    ft = { "markdown", "vimwiki" },
    dependencies = { "luarocks.nvim" },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = not DestNgxVim.snacks.image,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
          resolve_image_path = function(document_path, image_path, fallback)
            -- document_path is the path to the file that contains the image
            -- image_path is the potentially relative path to the image. for
            -- markdown it's `![](this text)`
            image_path = "Attachments/" .. image_path
            -- you can call the fallback function to get the default behavior
            return fallback(document_path, image_path)
          end,
        },
        neorg = { enabled = false, },
        html = { enabled = false, },
        css = { enabled = false, },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,                                     -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false,                                  -- auto show/hide images when the editor gains/looses focus
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
    }
  },
  {
    "HakonHarnes/img-clip.nvim",
    enabled = os.getenv "IS_WSL" ~= "true",
    ft = { "markdown" },
    opts = {
      default = {
        dir_path = "Attachments",
        relative_to_current_file = true,
      },
      filetypes = {
        markdown = {
          template = "![[$FILE_NAME]]", ---@type string
        },
        vimwiki = {
          template = "![[$FILE_NAME]]", ---@type string
        },
      }
    },
  },
  {
    "previm/previm",
    config = function()
      -- define global for open markdown preview, let g:previm_open_cmd = 'open -a Safari'
      if vim.fn.has('macunix') == 1 then
        vim.g.previm_open_cmd = "open -a Safari"
      else
        vim.g.previm_open_cmd = "xdg-open"
      end
    end,
    ft = { "markdown" },
    keys = {
      {
        "<leader>mm",
        "<cmd>PrevimOpen<cr>",
        desc = "Markdown preview",
      },
    },
  },
  {
    -- "epwalsh/obsidian.nvim", -- not use due to inactive development
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    event = function()
      if vim.fn.has('macunix') == 1 then
        return {
          "BufReadPre /Users/destnguyxn/projects/obsidian-vaults/Persona/30_atoms/**.md",
          "BufNewFile /Users/destnguyxn/projects/obsidian-vaults/Persona/30_atoms/**.md",
          "BufReadPre /Users/destnguyxn/projects/obsidian-vaults/Persona/20_incubator/**.md",
          "BufNewFile /Users/destnguyxn/projects/obsidian-vaults/Persona/20_incubator/**.md",
        }
      else
        return {
          "BufReadPre /home/destnguyxn/projects/obsidian-vaults/Persona/30_atoms/**.md",
          "BufNewFile /home/destnguyxn/projects/obsidian-vaults/Persona/30_atoms/**.md",
          "BufReadPre /home/destnguyxn/projects/obsidian-vaults/Persona/20_incubator/**.md",
          "BufNewFile /home/destnguyxn/projects/obsidian-vaults/Persona/20_incubator/**.md",
        }
      end
    end
    ,

    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("obsidian").setup({
        legacy_commands = false,
        workspaces = {
          {
            name = "Persona",
            path = "~/projects/obsidian-vaults/Persona",
          },
        },
        notes_subdir = "30_atoms",
        completion = {
          nvim_cmp = false,
          blink = true,
        },
        picker = {
          -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
          name = "fzf-lua",
          -- Optional, configure key mappings for the picker. These are the defaults.
          -- Not all pickers support all mappings.
          note_mappings = {
            -- Create a new note from your query.
            new = "<C-x>",
            -- Insert a link to the selected note.
            insert_link = "<C-l>",
          },
          tag_mappings = {
            -- Add tag(s) to current note.
            tag_note = "<C-x>",
            -- Insert a tag at the current location.
            insert_tag = "<C-l>",
          },
        },
        new_notes_location = "notes_subdir",
        templates = {
          subdir = "90_meta/01_templates",
          date_format = "%d-%m-%Y",
          time_format = "%H:%m",
        },
        attachments = {
          folder = "_attachments",
          img_text_func = function(path)
            local name = vim.fn.fnamemodify(path, ":t")
            return string.format("![[%s]]", name)
          end,
        },
        note_id_func = function(title)
          local suffix = ""
          if title ~= nil then
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end,
        frontmatter = {
          enabled = false,
          func = function(note)
            local out = { tags = note.tags }
            if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
              for k, v in pairs(note.metadata) do
                out[k] = v
              end
            end
            return out
          end,
        },
      })
    end,
  },
}
