return {
  {
    "vhyrro/luarocks.nvim",
    enabled = os.getenv "IS_WSL" ~= "true",
    lazy = false,
    priority = 1001, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
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
      vim.g.previm_open_cmd = "open -a Safari"
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
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    event = function()
      if vim.fn.has('macunix') == 1 then
        return {
          "BufReadPre /Users/destnguyxn/projects/obsidian-vaults/**.md",
          "BufNewFile /Users/destnguyxn/projects/obsidian-vaults/**.md",
        }
      else
        return {
          "BufReadPre /home/destnguyxn/projects/obsidian-vaults/**.md",
          "BufNewFile /home/destnguyxn/projects/obsidian-vaults/**.md",
        }
      end
    end
    ,

    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("obsidian").setup({
        workspaces = {
          {
            name = "Persona",
            path = "~/projects/obsidian-vaults/Persona",
          },
        },
        notes_subdir = "Zettelkasten",
        completion = {
          -- TODO: update config for blink.cmp
          nvim_cmp = false,
        },
        new_notes_location = "notes_subdir",
        templates = {
          subdir = "Templates",
          date_format = "%d-%m-%Y",
          time_format = "%H:%m",
        },
        attachments = {
          img_folder = "Zettelkasten/Attachments",
          img_text_func = function(client, path)
            path = client:vault_relative_path(path) or path
            return string.format("![[%s]]", path.name)
          end,
        },
        mappings = {
          ["<C-p>"] = {
            action = function()
              return "<CMD>ObsidianSearch<CR>"
            end,
            opts = { noremap = false, expr = true, buffer = true },
          },
          ["gd"] = {
            action = function()
              return require("obsidian").util.gf_passthrough()
            end,
            opts = { noremap = false, expr = true, buffer = true },
          },
        },
        note_id_func = function(title)
          -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
          -- In this case a note with the title 'My new note' will be given an ID that looks
          -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
          local suffix = ""
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end,
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

      -- HACK: fix error, disable completion.nvim_cmp option, manually register sources
      local cmp = require("cmp")
      cmp.register_source("obsidian", require("cmp_obsidian").new())
      cmp.register_source("obsidian_new", require("cmp_obsidian_new").new())
      cmp.register_source("obsidian_tags", require("cmp_obsidian_tags").new())
    end,
  },
  {
    "andrewferrier/wrapping.nvim",
    ft = { "markdown" },
    opts = {
      softener = { markdown = true },
      create_keymaps = false,
      notify_on_switch = false
    }
  }
}
