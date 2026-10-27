local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Show LSP progress as native progress messages (cmdline, statusline, terminal progress bar).
-- Source: `:h LspProgress`
vim.api.nvim_create_autocmd("LspProgress", {
  group = augroup("lsp_progress"),
  callback = function(ev)
    local value = ev.data.params.value
    -- JSON null arrives as vim.NIL, which nvim_echo rejects
    local function field(v)
      return v ~= vim.NIL and v or nil
    end
    vim.api.nvim_echo({ { field(value.message) or (value.kind == "end" and "done" or "") } }, false, {
      -- progress tokens are only unique per client
      id = ("lsp.%d.%s"):format(ev.data.client_id, ev.data.params.token),
      kind = "progress",
      source = "vim.lsp",
      title = field(value.title),
      status = value.kind ~= "end" and "running" or "success",
      percent = field(value.percentage),
    })
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Copy the relative path of the current file to the clipboard
vim.api.nvim_create_user_command("CopyRelPath", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify('Copied: "' .. path .. '" to the clipboard!')
end, {
  desc = "Copy the relative path of the current file to the clipboard",
})

-- Auto set filetype for eruby.yaml files that are not detected correctly for highlighting
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("eruby_yaml"),
  pattern = "eruby.yaml",
  command = "set filetype=yaml",
})
