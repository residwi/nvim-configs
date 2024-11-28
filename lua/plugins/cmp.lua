return {
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
		},
		opts = function()
			local cmp = require("cmp")

			return {
				completion = { completeopt = "menu,menuone,preview,noinsert" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping.confirm({ select = true }),

					-- If you prefer more traditional completion keymaps,
					-- you can uncomment the following lines
					--["<CR>"] = cmp.mapping.confirm { select = true },
					--["<Tab>"] = cmp.mapping.select_next_item(),
					--["<S-Tab>"] = cmp.mapping.select_prev_item(),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
				}, {
						{ name = "buffer" },
					}),
			}
		end,
	},

	-- snippets
	{
		"hrsh7th/nvim-cmp",
		optional = true,
		dependencies = {
			{
				"garymjr/nvim-snippets",
				opts = {
					friendly_snippets = true,
				},
				dependencies = { "rafamadriz/friendly-snippets" },
				-- native snippets. only needed on < 0.11, as 0.11 creates these by default
				keys = {
					{
						"<Tab>",
						function()
							if vim.snippet.active({ direction = 1 }) then
								vim.schedule(function()
									vim.snippet.jump(1)
								end)
								return
							end
							return "<Tab>"
						end,
						expr = true,
						silent = true,
						mode = "i",
					},
					{
						"<Tab>",
						function()
							vim.schedule(function()
								vim.snippet.jump(1)
							end)
						end,
						expr = true,
						silent = true,
						mode = "s",
					},
					{
						"<S-Tab>",
						function()
							if vim.snippet.active({ direction = -1 }) then
								vim.schedule(function()
									vim.snippet.jump(-1)
								end)
								return
							end
							return "<S-Tab>"
						end,
						expr = true,
						silent = true,
						mode = { "i", "s" },
					},
				},
			},
		},
		opts = function(_, opts)
			opts.snippet = {
				expand = function(args)
					return vim.snippet.expand(args.body)
				end,
			}

			table.insert(opts.sources, { name = "snippets" })
		end,
	},
}
