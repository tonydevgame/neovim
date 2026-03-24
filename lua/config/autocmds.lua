-- Autocmds are automatically loaded on the VeryLazy event

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  group    = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- Close auxiliary windows with just 'q'
vim.api.nvim_create_autocmd("FileType", {
  group   = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = { "help", "lspinfo", "checkhealth", "qf", "notify" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
