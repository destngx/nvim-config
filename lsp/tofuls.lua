---@type vim.lsp.Config
return {
    attach_mode = "autoattach",
    cmd = { "tofu-ls", "serve" },
    filetypes = { "terraform", "terraform-vars", "tf", "hcl" },
    root_markers = { ".terraform", ".tofu", ".git" },
}
