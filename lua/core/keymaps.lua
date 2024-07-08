vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move line to up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Yanking to the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Clear highlight search on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>")

-- Centered vertical scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- buffers
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>")
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>")
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>")
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>")
vim.keymap.set("n", "]b", "<cmd>bnext<CR>")
vim.keymap.set("n", "<leader>bb", "<cmd>e #<CR>")
vim.keymap.set("n", "<leader>`", "<cmd>e #<CR>")
