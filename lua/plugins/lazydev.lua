return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				"lazy.nvim",
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	-- Manage libuv types with lazy. Plugin will never be loaded
	{ "Bilal2453/luvit-meta", lazy = true },
	-- Add lazydev source to cmp
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
	},
}
