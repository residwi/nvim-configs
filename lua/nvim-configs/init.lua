require("nvim-configs.editor")
require("nvim-configs.remap")
require("nvim-configs.lazy_init")

vim.g.have_nerd_font = true

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Use tree style for netrw
vim.g.netrw_liststyle = 3

vim.cmd.colorscheme("catppuccin-mocha")
