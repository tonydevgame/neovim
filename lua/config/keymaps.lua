-- Keymaps are automatically loaded on the VeryLazy event

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling / searching
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without overwriting unnamed register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Lazygit
vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end, { desc = "Lazygit" })

-- Window splits
vim.keymap.set("n", "<leader>sv", "<C-w>v",  { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", "<C-w>s",  { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>se", "<C-w>=",  { desc = "Equal window sizes" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close split" })
