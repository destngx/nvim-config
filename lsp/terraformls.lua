---@type vim.lsp.Config
return {
    -- tofu-ls replaces terraform-ls when both are installed
    attach_mode = vim.fn.executable("tofu-ls") == 1 and "disable" or "autoattach",
    cmd = { "terraform-ls", "serve" },
    filetypes = { "terraform", "terraform-vars", "tf" },
    root_markers = { ".terraform", ".git" },
}
