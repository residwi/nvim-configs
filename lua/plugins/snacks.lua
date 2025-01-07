return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = false },
		dashboard = { enabled = false },
		notifier = { enabled = true },
		quickfile = { enabled = false },
		statuscolumn = { enabled = false },
		indent = { enabled = true },
		words = { enabled = true },
		styles = {
			notification = {
				wo = { wrap = true } -- Wrap notifications
			}
		}
	},
}
