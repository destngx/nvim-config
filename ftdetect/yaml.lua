vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.yml,*.yaml,*.apolicy",
	callback = function()
		vim.bo.filetype = "yaml"
	end,
	once = false,
})

