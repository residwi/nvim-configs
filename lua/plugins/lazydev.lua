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
}
