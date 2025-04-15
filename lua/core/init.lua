require("core.autocmds")
require("core.options")
require("core.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Add support for the LazyFile event
local Event = require("lazy.core.handler.event")
local lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

Event.mappings.LazyFile = { id = "LazyFile", event = lazy_file_events }
Event.mappings["User LazyFile"] = Event.mappings.LazyFile

_G.Util = require("utils")
Util.format.setup()

require("lazy").setup({
	spec = {
		{ import = "plugins.snacks" },
		-- Import mason plugin first so other plugins can override it
		-- and ensure LSP servers, formatters and linters are installed
		{ import = "plugins.mason" },
		{ import = "plugins" },
		{ import = "plugins.lsp.lang.typescript" },
		{ import = "plugins.lsp.lang.go" },
	},
	change_detection = { notify = false },
})

vim.cmd.colorscheme("catppuccin-mocha")
