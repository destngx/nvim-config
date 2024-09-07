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
    enabled = os.getenv "IS_WSL" ~= "true",
    lazy = true,
    event = "BufReadPre",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("plugins.config.image")
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    event = {
      "BufReadPre /home/destnguyxn/projects/obsidian-vaults/**.md",
      "BufNewFile /home/destnguyxn/projects/obsidian-vaults/**.md",
    },
    dependencies = { "nvim-lua/plenary.nvim", },
    config = function()
      require("plugins.config.obsidian")
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
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
    "andrewferrier/wrapping.nvim",
    event = "BufReadPre",
    opts = {
      softener = { markdown = true },
      create_keymaps = false,
      notify_on_switch = false
    }
  },
}
