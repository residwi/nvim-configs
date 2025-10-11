require("core.autocmds")
require("core.options")
require("core.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
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
  install = { colorscheme = { "catppuccin-mocha", "habamax" } },
})

vim.cmd.colorscheme("catppuccin-mocha")
