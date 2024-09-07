return {
  {
    "jcdickinson/codeium.nvim",
    cond = DestNgxVim.plugins.ai.codeium.enabled,
    event = "InsertEnter",
    cmd = "Codeium",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = true,
  },
}

