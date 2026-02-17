local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	group = augroup,
	pattern = "*",
	command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "json", "jsonc", "markdown" },
	callback = function()
		vim.opt.conceallevel = 0
	end,
})
