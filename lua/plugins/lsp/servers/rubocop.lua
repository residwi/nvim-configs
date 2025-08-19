local M = {}

-- Only run rubocop if a Gemfile is present in the project root
local rubocop_command = vim.fn.filereadable(vim.fs.joinpath(vim.fn.getcwd(), "Gemfile")) == 1
    and { "bundle", "exec", "rubocop", "--lsp" }
  or { vim.fn.expand("~/.asdf/shims/rubocop"), "--lsp" }

M.config = {
  mason = false,
  cmd = rubocop_command,
}

return M
