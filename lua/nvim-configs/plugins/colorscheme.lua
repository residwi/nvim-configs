return {
	"olimorris/onedarkpro.nvim",
	priority = 1000,
	init = function()
		local color = require("onedarkpro.helpers")

		require("onedarkpro").setup({
			colors = {
				dark = {
					telescope_selection = color.lighten("bg", 2, "onedark"),
				},
			},
			highlights = {
				-- Telescope
				TelescopeBorder = { fg = "${orange}", bg = "${float_bg}" },
				TelescopePromptCounter = { bg = "${float_bg}", fg = "${gray}" },
				TelescopePromptPrefix = { fg = "${blue}" },
				TelescopeSelectionCaret = { fg = "${blue}" },
				TelescopeSelection = { bg = "${telescope_selection}" },

				-- Editor
				Cursor = { bg = color.lighten("white", 2, "onedark"), fg = "${bg}" },
				CursorLineNr = { fg = "${blue}" },
			},
		})

		vim.cmd.colorscheme("onedark_vivid")
	end,
}
