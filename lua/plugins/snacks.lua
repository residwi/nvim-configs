return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		notifier = { enabled = true },
		indent = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		styles = {
			notification = {
				wo = { wrap = true } -- Wrap notifications
			}
		},
		words = { enabled = true },
	},
	keys = {
		{ "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
		{ "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
	}
}
