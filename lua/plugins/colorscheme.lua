return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			custom_highlights = function(C)
				return {
					SnacksIndent = { fg = C.surface0 },
					SnacksIndentScope = { fg = C.overlay0 },
				}
			end,
			integrations = {
				lsp_trouble = true,
				mason = true,
				blink_cmp = true,
				native_lsp = {
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
						ok = { "undercurl" },
					},
				},
				snacks = true,
				which_key = true,
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
		end,
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
