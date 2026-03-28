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

-- JIRA integration
local jira_ok, jira = pcall(require, "jira")
if jira_ok then
  -- Browser actions (no API needed)
  vim.keymap.set("n", "<leader>jo", jira.open_ticket_under_cursor, { desc = "Open ticket in browser" })
  vim.keymap.set("v", "<leader>jo", jira.open_ticket_from_selection, { desc = "Open ticket in browser" })
  vim.keymap.set("n", "<leader>jp", jira.open_ticket_prompt, { desc = "Open ticket (prompt)" })
  vim.keymap.set("n", "<leader>jb", jira.open_board, { desc = "Open board in browser" })
  vim.keymap.set("n", "<leader>jy", jira.copy_ticket_url, { desc = "Copy ticket URL" })
  
  -- Terminal actions (requires API token)
  vim.keymap.set("n", "<leader>jv", jira.view_ticket_under_cursor_terminal, { desc = "View ticket in terminal" })
  vim.keymap.set("n", "<leader>js", jira.search_tickets_terminal, { desc = "Search tickets in terminal" })
  vim.keymap.set("n", "<leader>jm", jira.list_my_tickets_terminal, { desc = "My tickets in terminal" })
  vim.keymap.set("n", "<leader>jr", jira.list_recent_tickets_terminal, { desc = "Recent tickets in terminal" })
  vim.keymap.set("n", "<leader>jt", jira.list_tickets_by_status_terminal, { desc = "Tickets by status" })
  vim.keymap.set("n", "<leader>jl", jira.list_tickets_by_project_terminal, { desc = "List project tickets" })
  vim.keymap.set("n", "<leader>jc", jira.create_issue, { desc = "Create issue (browser)" })
  
  -- JIRA commands
  vim.api.nvim_create_user_command("JiraOpen", function(opts)
    if opts.args and opts.args ~= "" then
      jira.open_ticket(opts.args)
    else
      jira.open_ticket_prompt()
    end
  end, { nargs = "?", desc = "Open JIRA ticket in browser" })
  
  vim.api.nvim_create_user_command("JiraView", function(opts)
    if opts.args and opts.args ~= "" then
      jira.view_ticket_in_terminal(opts.args)
    else
      jira.view_ticket_under_cursor_terminal()
    end
  end, { nargs = "?", desc = "View JIRA ticket in terminal" })
  
  vim.api.nvim_create_user_command("JiraSearch", function(opts)
    jira.search_tickets_terminal(opts.args)
  end, { nargs = "?", desc = "Search JIRA tickets in terminal" })
  
  vim.api.nvim_create_user_command("JiraMy", jira.list_my_tickets_terminal, { desc = "List my tickets in terminal" })
  vim.api.nvim_create_user_command("JiraRecent", jira.list_recent_tickets_terminal, { desc = "List recent tickets in terminal" })
  
  vim.api.nvim_create_user_command("JiraTest", jira.test_api_connection, { desc = "Test JIRA API connection" })
  
  vim.api.nvim_create_user_command("JiraBoard", jira.open_board, { desc = "Open JIRA board in browser" })
  vim.api.nvim_create_user_command("JiraCreate", jira.create_issue, { desc = "Create JIRA issue in browser" })
  vim.api.nvim_create_user_command("JiraSetUrl", function(opts)
    jira.set_url(opts.args)
  end, { nargs = "?", desc = "Set or view JIRA instance URL" })
end
