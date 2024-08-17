return {
	"nvim-telescope/telescope-file-browser.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup({
			extensions = {
				file_browser = {
					theme = "ivy",
					cwd_to_path = true,
					hijack_netrw = true,
					initial_mode = "normal",
					grouped = true,
					hidden = true,
					mappings = {
						i = {
							["<C-f>"] = false, -- disable toggle_browser mapping
							["<C-t>"] = false, -- disable change_cwd mapping
						},
						n = {
							f = false, -- disable toggle_browser mapping
							t = false, -- disable change_cwd mapping
						},
					},
				},
			},
		})

		require("telescope").load_extension("file_browser")

		vim.keymap.set("n", "<leader>fe", function()
			require("telescope").extensions.file_browser.file_browser({
				path = vim.fn.expand("%:p:h"),
				select_buffer = true,
			})
		end, { desc = "[F]ind [E]xplorer" })
	end,
}
