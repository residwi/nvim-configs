return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
				filetypes = {
					markdown = true,
					help = true,
				},
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"zbirenbaum/copilot-cmp",
				dependencies = "copilot.lua",
				config = function()
					require("copilot_cmp").setup()
				end
			},
		},
		opts = function(_, opts)
			table.insert(opts.sources, 1, {
				name = "copilot",
				group_index = 1,
				priority = 100,
			})
		end,
	},
}
