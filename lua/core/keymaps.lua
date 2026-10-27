vim.g.mapleader = " "

-- Move line to up or down
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

-- Yanking to the system clipboard
vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Clear highlight search on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>")

-- Centered vertical scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- buffers
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>")
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>")
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>")
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>")
vim.keymap.set("n", "]b", "<cmd>bnext<CR>")
vim.keymap.set("n", "<leader>bb", "<cmd>e #<CR>")
vim.keymap.set("n", "<leader>`", "<cmd>e #<CR>")

-- search selected text
vim.keymap.set("x", "<C-n>", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>")

-- Paste without replacing the current selection (native `P` keeps the register)
vim.keymap.set("x", "p", [[P`[v`]=]])

-- Incremental selection (built-in treesitter/LSP `an`/`in`).
-- mini.ai overrides `an`/`in` when it loads, so copy them first. See `:h MiniAi-default-an-in`.
local function copy_keymap(mode, from_lhs, to_lhs, desc)
  local keymap = vim.fn.maparg(from_lhs, mode, false, true)
  vim.keymap.set(mode, to_lhs, keymap.callback or keymap.rhs, { desc = desc })
end
copy_keymap("x", "an", "<C-Space>", "Increment Selection")
copy_keymap("x", "in", "<BS>", "Decrement Selection")
vim.keymap.set("n", "<C-Space>", "v<C-Space>", { remap = true, desc = "Increment Selection" })

-- Disable accidental command-line window
vim.keymap.set("n", "q:", "<Nop>")

-- Copy relative file path to clipboard
vim.keymap.set("n", "<leader>cp", "<cmd>CopyRelPath<cr>", { desc = "Copy relative path" })
