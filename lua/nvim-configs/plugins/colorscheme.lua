return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {},
	},
	{
		"olimorris/onedarkpro.nvim",
		lazy = true,
		config = function()
			local color = require("onedarkpro.helpers")

			require("onedarkpro").setup({
				colors = {
					onedark = { bg = "#1a212e" },
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

					-- Ruby
					["@string.special.symbol.ruby"] = { fg = "${cyan}" },
					["@variable.ruby"] = { fg = "${fg}" },
					["@variable.parameter.ruby"] = { link = "@variable.ruby" },
					["@lsp.type.variable.ruby"] = { link = "@variable.ruby" },
				},
			})
		end,
	},
	{
		"navarasu/onedark.nvim",
		lazy = true,
		config = function()
			require("onedark").setup({
				style = "deep",
			})
		end,
	},
}
