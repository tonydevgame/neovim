-- JIRA integration utilities
-- This module provides functions to open JIRA tickets and pages

local M = {}

-- Get JIRA instance URL from environment variable
M.jira_url = os.getenv("ATLASSIAN_INSTANCE_URL") or "https://your-company.atlassian.net"

-- URL encode function
local function url_encode(str)
  if str then
    str = string.gsub(str, "\n", "\r\n")
    str = string.gsub(str, "([^%w %-%_%.%~])",
      function(c) return string.format("%%%02X", string.byte(c)) end)
    str = string.gsub(str, " ", "+")
  end
  return str
end

-- Function to open URL in browser
local function open_url(url)
  local cmd
  if vim.fn.has("mac") == 1 then
    cmd = "open"
  elseif vim.fn.has("unix") == 1 then
    cmd = "xdg-open"
  elseif vim.fn.has("win32") == 1 then
    cmd = "start"
  else
    vim.notify("Unsupported OS for opening URLs", vim.log.levels.ERROR)
    return
  end
  vim.fn.jobstart({cmd, url}, {detach = true})
end

-- Function to extract JIRA ticket from text
local function extract_ticket(text)
  -- Match pattern like ABC-123, PROJ-456, etc.
  local ticket = text:match("([A-Z][A-Z0-9]+-[0-9]+)")
  return ticket
end

-- Open JIRA ticket in browser
function M.open_ticket(ticket)
  if not ticket or ticket == "" then
    vim.notify("No ticket specified", vim.log.levels.WARN)
    return
  end
  
  -- Clean up ticket (remove extra spaces, etc.)
  ticket = ticket:match("^%s*(.-)%s*$")
  
  -- If not a full ticket format, try to match
  if not ticket:match("[A-Z]+-[0-9]+") then
    vim.notify("Invalid ticket format. Expected: PROJECT-123", vim.log.levels.WARN)
    return
  end
  
  local url = M.jira_url .. "/browse/" .. ticket
  open_url(url)
  vim.notify("Opening " .. ticket .. " in browser", vim.log.levels.INFO)
end

-- Open ticket under cursor
function M.open_ticket_under_cursor()
  -- Get word under cursor
  local word = vim.fn.expand("<cword>")
  local ticket = extract_ticket(word)
  
  if not ticket then
    -- Try to get the whole line and search for ticket
    local line = vim.fn.getline(".")
    ticket = extract_ticket(line)
  end
  
  if ticket then
    M.open_ticket(ticket)
  else
    vim.notify("No JIRA ticket found under cursor", vim.log.levels.WARN)
  end
end

-- Open ticket from visual selection
function M.open_ticket_from_selection()
  -- Get visual selection
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  local ticket = extract_ticket(text)
  
  if ticket then
    M.open_ticket(ticket)
  else
    vim.notify("No JIRA ticket found in selection", vim.log.levels.WARN)
  end
end

-- Prompt for ticket and open
function M.open_ticket_prompt()
  vim.ui.input({
    prompt = "Enter JIRA ticket (e.g., ABC-123): ",
    default = "",
  }, function(input)
    if input then
      M.open_ticket(input)
    end
  end)
end

-- Open JIRA board
function M.open_board()
  local url = M.jira_url .. "/secure/RapidBoard.jspa"
  open_url(url)
  vim.notify("Opening JIRA board in browser", vim.log.levels.INFO)
end

-- Open JIRA search
function M.open_search()
  local url = M.jira_url .. "/issues/?jql="
  open_url(url)
  vim.notify("Opening JIRA search in browser", vim.log.levels.INFO)
end

-- Search for tickets assigned to me
function M.open_my_tickets()
  local url = M.jira_url .. "/issues/?jql=assignee=currentuser()+AND+resolution=Unresolved+ORDER+BY+updated+DESC"
  open_url(url)
  vim.notify("Opening your assigned tickets", vim.log.levels.INFO)
end

-- Create new issue
function M.create_issue()
  local url = M.jira_url .. "/secure/CreateIssue.jspa"
  open_url(url)
  vim.notify("Opening JIRA create issue page", vim.log.levels.INFO)
end

-- Copy ticket URL to clipboard
function M.copy_ticket_url()
  local word = vim.fn.expand("<cword>")
  local ticket = extract_ticket(word)
  
  if not ticket then
    local line = vim.fn.getline(".")
    ticket = extract_ticket(line)
  end
  
  if ticket then
    local url = M.jira_url .. "/browse/" .. ticket
    vim.fn.setreg("+", url)
    vim.notify("Copied URL: " .. url, vim.log.levels.INFO)
  else
    vim.notify("No JIRA ticket found under cursor", vim.log.levels.WARN)
  end
end

-- Set JIRA URL
function M.set_url(url)
  if url and url ~= "" then
    M.jira_url = url
    vim.notify("JIRA URL set to: " .. M.jira_url, vim.log.levels.INFO)
  else
    vim.notify("Current JIRA URL: " .. M.jira_url, vim.log.levels.INFO)
  end
end

-- View ticket in terminal (requires API credentials)
function M.view_ticket_in_terminal(ticket)
  local email = os.getenv("ATLASSIAN_EMAIL")
  local token = os.getenv("ATLASSIAN_API_TOKEN")
  
  if not email or not token or token == "your-api-token-here" then
    vim.notify("API credentials not configured. Set ATLASSIAN_EMAIL and ATLASSIAN_API_TOKEN", vim.log.levels.WARN)
    vim.notify("Run: ./scripts/install-mcp.sh to configure", vim.log.levels.INFO)
    return
  end
  
  if not ticket or ticket == "" then
    vim.notify("No ticket specified", vim.log.levels.WARN)
    return
  end
  
  ticket = ticket:match("^%s*(.-)%s*$")
  if not ticket:match("[A-Z]+-[0-9]+") then
    vim.notify("Invalid ticket format. Expected: PROJECT-123", vim.log.levels.WARN)
    return
  end
  
  vim.notify("Fetching " .. ticket .. "...", vim.log.levels.INFO)
  
  local url = M.jira_url .. "/rest/api/3/issue/" .. ticket
  local auth = vim.fn.system("echo -n " .. vim.fn.shellescape(email .. ":" .. token) .. " | base64")
  auth = auth:gsub("%s+", "")
  
  local curl_cmd = string.format(
    'curl -s -H "Authorization: Basic %s" -H "Content-Type: application/json" %s',
    auth,
    vim.fn.shellescape(url)
  )
  
  vim.fn.jobstart(curl_cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local json_str = table.concat(data, "\n")
        local ok, json = pcall(vim.json.decode, json_str)
        
        if ok and json.key then
          M.display_ticket(json)
        else
          vim.notify("Failed to fetch ticket. Check credentials and ticket number.", vim.log.levels.ERROR)
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        local msg = table.concat(data, "\n"):match("^%s*(.-)%s*$")
        if msg and msg ~= "" and not msg:match("^%%") then
          vim.notify("Error: " .. msg, vim.log.levels.ERROR)
        end
      end
    end,
  })
end

-- Display ticket in a floating window
function M.display_ticket(ticket_data)
  local lines = {
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
    string.format("🎫 %s: %s", ticket_data.key, ticket_data.fields.summary),
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
    "",
    "📊 Status: " .. ticket_data.fields.status.name,
    "👤 Assignee: " .. (ticket_data.fields.assignee and ticket_data.fields.assignee.displayName or "Unassigned"),
    "📝 Type: " .. ticket_data.fields.issuetype.name,
    "⚡ Priority: " .. (ticket_data.fields.priority and ticket_data.fields.priority.name or "None"),
    "",
    "📖 Description:",
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
  }
  
  if ticket_data.fields.description then
    local desc = ticket_data.fields.description
    -- Simple text extraction (Atlassian Document Format)
    if type(desc) == "table" and desc.content then
      for _, block in ipairs(desc.content) do
        if block.type == "paragraph" and block.content then
          for _, text_node in ipairs(block.content) do
            if text_node.text then
              table.insert(lines, text_node.text)
            end
          end
        end
      end
    else
      table.insert(lines, tostring(desc))
    end
  else
    table.insert(lines, "(No description)")
  end
  
  table.insert(lines, "")
  table.insert(lines, "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
  table.insert(lines, "Press 'q' to close | 'o' to open in browser")
  
  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  
  -- Calculate window size
  local width = math.min(100, vim.o.columns - 4)
  local height = math.min(30, vim.o.lines - 4)
  
  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' JIRA Ticket ',
    title_pos = 'center',
  })
  
  -- Keymaps for the floating window
  local ticket_key = ticket_data.key
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, nowait = true })
  vim.keymap.set('n', 'o', function()
    vim.cmd('close')
    M.open_ticket(ticket_key)
  end, { buffer = buf, nowait = true })
  vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, nowait = true })
end

-- View ticket under cursor in terminal
function M.view_ticket_under_cursor_terminal()
  local word = vim.fn.expand("<cword>")
  local ticket = word:match("([A-Z][A-Z0-9]+-[0-9]+)")
  
  if not ticket then
    local line = vim.fn.getline(".")
    ticket = line:match("([A-Z][A-Z0-9]+-[0-9]+)")
  end
  
  if ticket then
    M.view_ticket_in_terminal(ticket)
  else
    vim.notify("No JIRA ticket found under cursor", vim.log.levels.WARN)
  end
end

-- Helper function to make authenticated API request
local function jira_api_call(endpoint, callback)
  local email = os.getenv("ATLASSIAN_EMAIL")
  local token = os.getenv("ATLASSIAN_API_TOKEN")
  
  if not email or not token or token == "your-api-token-here" then
    vim.notify("API credentials not configured. Set ATLASSIAN_EMAIL and ATLASSIAN_API_TOKEN", vim.log.levels.WARN)
    return
  end
  
  local url = M.jira_url .. endpoint
  local auth = vim.fn.system("echo -n " .. vim.fn.shellescape(email .. ":" .. token) .. " | base64")
  auth = auth:gsub("%s+", "")
  
  local curl_cmd = string.format(
    'curl -s -H "Authorization: Basic %s" -H "Content-Type: application/json" %s',
    auth,
    vim.fn.shellescape(url)
  )
  
  vim.fn.jobstart(curl_cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local json_str = table.concat(data, "\n")
        
        -- Debug: show raw response if it's short
        if #json_str < 200 then
          vim.notify("API Response: " .. json_str, vim.log.levels.DEBUG)
        end
        
        local ok, json = pcall(vim.json.decode, json_str)
        if ok then
          -- Check for JIRA API errors
          if json.errorMessages or json.errors then
            local errors = json.errorMessages or {}
            if json.errors then
              for k, v in pairs(json.errors) do
                table.insert(errors, k .. ": " .. v)
              end
            end
            vim.notify("JIRA API Error: " .. table.concat(errors, ", "), vim.log.levels.ERROR)
          else
            callback(json)
          end
        else
          vim.notify("Failed to parse response: " .. json_str:sub(1, 100), vim.log.levels.ERROR)
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        local msg = table.concat(data, "\n"):match("^%s*(.-)%s*$")
        if msg and msg ~= "" and not msg:match("^%%") then
          vim.notify("API Error: " .. msg, vim.log.levels.ERROR)
        end
      end
    end,
  })
end

-- Helper function to make authenticated POST API request
local function jira_api_call_post(endpoint, body, callback)
  local email = os.getenv("ATLASSIAN_EMAIL")
  local token = os.getenv("ATLASSIAN_API_TOKEN")
  
  if not email or not token or token == "your-api-token-here" then
    vim.notify("API credentials not configured. Set ATLASSIAN_EMAIL and ATLASSIAN_API_TOKEN", vim.log.levels.WARN)
    return
  end
  
  local url = M.jira_url .. endpoint
  local auth = vim.fn.system("echo -n " .. vim.fn.shellescape(email .. ":" .. token) .. " | base64")
  auth = auth:gsub("%s+", "")
  
  local json_body = vim.fn.json_encode(body)
  
  -- Debug: show the request body for JQL searches
  if body.jql then
    vim.notify("JQL Query: " .. body.jql, vim.log.levels.DEBUG)
  end
  
  local curl_cmd = string.format(
    'curl -s -X POST -H "Authorization: Basic %s" -H "Content-Type: application/json" -d %s %s',
    auth,
    vim.fn.shellescape(json_body),
    vim.fn.shellescape(url)
  )
  
  vim.fn.jobstart(curl_cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local json_str = table.concat(data, "\n")
        
        local ok, json = pcall(vim.json.decode, json_str)
        if ok then
          -- Check for JIRA API errors
          if json.errorMessages or json.errors then
            local errors = json.errorMessages or {}
            if json.errors then
              for k, v in pairs(json.errors) do
                table.insert(errors, k .. ": " .. v)
              end
            end
            vim.notify("JIRA API Error: " .. table.concat(errors, ", "), vim.log.levels.ERROR)
            -- Show the full response for debugging
            vim.notify("Full response: " .. json_str:sub(1, 500), vim.log.levels.DEBUG)
          else
            callback(json)
          end
        else
          vim.notify("Failed to parse response: " .. json_str:sub(1, 200), vim.log.levels.ERROR)
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        local msg = table.concat(data, "\n"):match("^%s*(.-)%s*$")
        if msg and msg ~= "" and not msg:match("^%%") then
          vim.notify("API Error: " .. msg, vim.log.levels.ERROR)
        end
      end
    end,
  })
end

-- Display list of tickets
local function display_ticket_list(tickets, title)
  local lines = {
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
    string.format("🔍 %s", title),
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
    "",
  }
  
  local ticket_keys = {}
  
  if #tickets == 0 then
    table.insert(lines, "No tickets found")
  else
    for _, ticket in ipairs(tickets) do
      local key = ticket.key
      local summary = ticket.fields.summary
      local status = ticket.fields.status.name
      -- Handle assignee properly (can be nil, vim.NIL, or a table)
      local assignee = "Unassigned"
      if ticket.fields.assignee and type(ticket.fields.assignee) == "table" then
        assignee = ticket.fields.assignee.displayName or "Unassigned"
      end
      
      table.insert(ticket_keys, key)
      table.insert(lines, string.format("[%d] %s", #ticket_keys, key))
      table.insert(lines, string.format("    📝 %s", summary))
      table.insert(lines, string.format("    📊 %s  👤 %s", status, assignee))
      table.insert(lines, "")
    end
  end
  
  table.insert(lines, "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
  table.insert(lines, "Press number to view ticket | 'o' open in browser | 'q' to close")
  
  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  
  -- Calculate window size
  local width = math.min(120, vim.o.columns - 4)
  local height = math.min(40, vim.o.lines - 4)
  
  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' JIRA Search Results ',
    title_pos = 'center',
  })
  
  -- Keymaps for the floating window
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, nowait = true })
  vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, nowait = true })
  
  -- Number keymaps to view specific ticket
  for i, key in ipairs(ticket_keys) do
    vim.keymap.set('n', tostring(i), function()
      vim.cmd('close')
      M.view_ticket_in_terminal(key)
    end, { buffer = buf, nowait = true })
  end
  
  -- 'o' to open first ticket in browser
  if #ticket_keys > 0 then
    vim.keymap.set('n', 'o', function()
      vim.cmd('close')
      M.open_ticket(ticket_keys[1])
    end, { buffer = buf, nowait = true })
  end
end

-- List my assigned tickets in terminal
function M.list_my_tickets_terminal()
  vim.notify("Fetching your assigned tickets...", vim.log.levels.INFO)
  
  local jql = "assignee=currentuser() AND resolution=Unresolved ORDER BY updated DESC"
  
  jira_api_call_post("/rest/api/3/search/jql", {
    jql = jql,
    maxResults = 20,
    fields = {"summary", "status", "assignee", "issuetype", "priority"}
  }, function(json)
    if json and json.issues then
      display_ticket_list(json.issues, string.format("My Assigned Tickets (%d)", json.total or #json.issues))
    else
      vim.notify("Failed to fetch tickets", vim.log.levels.ERROR)
    end
  end)
end

-- Search tickets in terminal
function M.search_tickets_terminal(query)
  if not query or query == "" then
    vim.ui.input({
      prompt = "Search JIRA (text search or JQL): ",
      default = "",
    }, function(input)
      if input then
        M.search_tickets_terminal(input)
      end
    end)
    return
  end
  
  vim.notify("Searching for: " .. query, vim.log.levels.INFO)
  
  -- Check if it's a ticket key (e.g., CMW-9253)
  local ticket_key = query:match("([A-Z][A-Z0-9]+-[0-9]+)")
  if ticket_key then
    -- Direct ticket lookup
    vim.notify("Looking up ticket: " .. ticket_key, vim.log.levels.INFO)
    M.view_ticket_in_terminal(ticket_key)
    return
  end
  
  -- Check if it's JQL (contains = or ORDER BY)
  local jql
  if query:match("=") or query:match("ORDER%s+BY") then
    jql = query
  else
    -- Improved text search - search in summary and description
    jql = string.format('(summary ~ "%s" OR description ~ "%s" OR text ~ "%s") ORDER BY updated DESC', 
                       query, query, query)
  end
  
  -- Debug: show the JQL
  vim.notify("JQL: " .. jql, vim.log.levels.DEBUG)
  
  jira_api_call_post("/rest/api/3/search/jql", {
    jql = jql,
    maxResults = 20,
    fields = {"summary", "status", "assignee", "issuetype", "priority"}
  }, function(json)
    if json and json.issues then
      local count = json.total or #json.issues
      if count == 0 then
        vim.notify("No tickets found matching: " .. query, vim.log.levels.WARN)
      else
        display_ticket_list(json.issues, string.format('Search: "%s" (%d results)', query, count))
      end
    else
      vim.notify("Failed to search tickets", vim.log.levels.ERROR)
    end
  end)
end

-- List recent tickets in terminal
function M.list_recent_tickets_terminal()
  vim.notify("Fetching recent tickets...", vim.log.levels.INFO)
  
  local jql = "updated >= -7d ORDER BY updated DESC"
  
  jira_api_call_post("/rest/api/3/search/jql", {
    jql = jql,
    maxResults = 20,
    fields = {"summary", "status", "assignee", "issuetype", "priority"}
  }, function(json)
    if json and json.issues then
      display_ticket_list(json.issues, string.format("Recent Tickets (Last 7 days) (%d)", json.total or #json.issues))
    else
      vim.notify("Failed to fetch tickets", vim.log.levels.ERROR)
    end
  end)
end

-- List tickets by status
function M.list_tickets_by_status_terminal(status)
  if not status or status == "" then
    vim.ui.input({
      prompt = "Enter status (e.g., 'In Progress', 'Done'): ",
      default = "In Progress",
    }, function(input)
      if input then
        M.list_tickets_by_status_terminal(input)
      end
    end)
    return
  end
  
  vim.notify("Fetching tickets with status: " .. status, vim.log.levels.INFO)
  
  local jql = string.format('status = "%s" ORDER BY updated DESC', status)
  
  jira_api_call_post("/rest/api/3/search/jql", {
    jql = jql,
    maxResults = 20,
    fields = {"summary", "status", "assignee", "issuetype", "priority"}
  }, function(json)
    if json and json.issues then
      display_ticket_list(json.issues, string.format('Status: %s (%d)', status, json.total or #json.issues))
    else
      vim.notify("Failed to fetch tickets", vim.log.levels.ERROR)
    end
  end)
end

-- List tickets by project
function M.list_tickets_by_project_terminal(project)
  if not project or project == "" then
    vim.ui.input({
      prompt = "Enter project key (e.g., CMW): ",
      default = "CMW",
    }, function(input)
      if input then
        M.list_tickets_by_project_terminal(input)
      end
    end)
    return
  end
  
  vim.notify("Fetching tickets for project: " .. project, vim.log.levels.INFO)
  
  local jql = string.format('project = "%s" ORDER BY updated DESC', project)
  
  jira_api_call_post("/rest/api/3/search/jql", {
    jql = jql,
    maxResults = 20,
    fields = {"summary", "status", "assignee", "issuetype", "priority"}
  }, function(json)
    if json and json.issues then
      local count = json.total or #json.issues
      if count == 0 then
        vim.notify("No tickets found for project: " .. project, vim.log.levels.WARN)
      else
        display_ticket_list(json.issues, string.format('Project: %s (%d)', project, count))
      end
    else
      vim.notify("Failed to fetch tickets", vim.log.levels.ERROR)
    end
  end)
end

-- Test API connection
function M.test_api_connection()
  vim.notify("Testing JIRA API connection...", vim.log.levels.INFO)
  
  jira_api_call("/rest/api/3/myself", function(json)
    if json and json.displayName then
      vim.notify("✅ API Connected! Logged in as: " .. json.displayName .. " (" .. json.emailAddress .. ")", vim.log.levels.INFO)
    else
      vim.notify("❌ API test failed", vim.log.levels.ERROR)
    end
  end)
end

return M
