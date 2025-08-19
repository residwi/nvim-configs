local M = {}

M.config = {
  mason = false,
  cmd = { vim.fn.expand("~/.asdf/shims/ruby-lsp") }
}

return M
