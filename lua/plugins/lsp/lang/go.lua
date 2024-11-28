return {
	"ray-x/go.nvim",
	lazy = true,
	dependencies = {
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	ft = { "go", "gomod" },
	config = function(_, opts)
		require("go").setup(opts)
	end,
}
