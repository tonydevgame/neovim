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

-- File search
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>",      { desc = "Find files" })
vim.keymap.set("n", "<leader>fs", "<cmd>FzfLua live_grep<cr>",  { desc = "Search in files (grep)" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>",    { desc = "Find open buffers" })

-- Window splits
vim.keymap.set("n", "<leader>sv", "<C-w>v",  { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", "<C-w>s",  { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>se", "<C-w>=",  { desc = "Equal window sizes" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close split" })

-- Window navigation (move between splits)
vim.keymap.set("n", "<leader>ll", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<leader>lr", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<leader>lk", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<leader>lj", "<C-w>j", { desc = "Move to lower window" })

-- Diagnostics
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>D", vim.diagnostic.setloclist,  { desc = "Diagnostics list" })
