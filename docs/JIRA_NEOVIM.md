# Neovim JIRA Integration (Lua)

Quick browser-based JIRA ticket access from within Neovim.

## ⚡ Quick Start

### 1. Set your JIRA instance URL

Add to `~/.zshrc` (or `~/.bashrc`):

```bash
export ATLASSIAN_INSTANCE_URL="https://your-company.atlassian.net"
```

Then reload your shell:

```bash
source ~/.zshrc
```

### 2. Use it!

Put your cursor on a JIRA ticket like `ABC-123` and press `<leader>jo` to open it in your browser!

## ⌨️ Keybindings

All JIRA commands use the `<leader>j` prefix:

| Key          | Action                       | Example Usage                                 |
| ------------ | ---------------------------- | --------------------------------------------- |
| `<leader>jo` | Open ticket under cursor     | Cursor on `ABC-123`, press `<leader>jo`       |
| `<leader>jo` | Open ticket from selection   | Select `ABC-123` in visual mode, `<leader>jo` |
| `<leader>jp` | Open ticket (prompt)         | Enter ticket manually                         |
| `<leader>jb` | Open JIRA board              | Opens your team's sprint board                |
| `<leader>js` | Open JIRA search             | Opens JIRA issue search                       |
| `<leader>jm` | Open my assigned tickets     | Opens issues assigned to you                  |
| `<leader>jc` | Create new issue             | Opens JIRA create issue page                  |
| `<leader>jy` | Copy ticket URL to clipboard | Copies full URL of ticket under cursor        |

## 💬 Commands

All commands are also available as Neovim commands:

```vim
:JiraOpen ABC-123      " Open specific ticket
:JiraOpen              " Prompt for ticket
:JiraBoard             " Open board
:JiraMy                " Open your tickets
:JiraCreate            " Create new issue
:JiraSearch            " Open search
:JiraSetUrl [URL]      " Set or view JIRA instance URL
```

## 📝 Usage Examples

### Open ticket under cursor

```lua
-- In any file, including code comments:
-- TODO: Fix bug ABC-123
--       ^^^^^^^^ cursor here, press <leader>jo
```

```python
# JIRA: ABC-456
#       ^^^^^^^ cursor here, press <leader>jo
```

```markdown
See ticket [ABC-789](some-link)
^^^^^^^ cursor here, press <leader>jo
```

### Visual selection

```
1. Select text containing ABC-123
2. Press <leader>jo
3. Browser opens to ABC-123
```

### Quick open with prompt

```
1. Press <leader>jp
2. Type: ABC-123
3. Press Enter
```

### Copy URL for sharing

```
1. Put cursor on ABC-123
2. Press <leader>jy
3. URL is copied to clipboard
4. Paste anywhere: https://your-company.atlassian.net/browse/ABC-123
```

## 🎯 Workflow Examples

### Code Review Workflow

```lua
-- Review comments in code:
-- TODO: ABC-123 - Fix authentication bug
--       Press <leader>jo to open ticket
-- BLOCKED: ABC-456 needs to be resolved first
--          Press <leader>jo to check status
```

### Commit Messages

```bash
# In git commit message:
# fix: resolve login issue (ABC-789)
#                           ^^^^^^^ <leader>jo to verify ticket
```

### Documentation

```markdown
# API Changes

Related tickets:

- ABC-100: Add new endpoint
  ^^^^^^^ <leader>jo to open
- ABC-101: Update authentication
  ^^^^^^^ <leader>jo to open
```

### Standup Notes

```markdown
## Today

- Working on ABC-555 (frontend bug)
  ^^^^^^^ <leader>jo to review
- Will pick up ABC-556 next
  ^^^^^^^ <leader>jo to check priority
```

## 🔧 Configuration

### Change JIRA URL at runtime

```vim
:JiraSetUrl https://different-company.atlassian.net
```

View current URL:

```vim
:JiraSetUrl
```

### Custom Keybindings

Edit `lua/plugins/jira.lua` to change keybindings:

```lua
-- Change from <leader>jo to <leader>o
vim.keymap.set("n", "<leader>o", open_ticket_under_cursor, { desc = "Open ticket" })
```

## 🔍 Ticket Detection

The plugin automatically detects JIRA tickets in the format:

- `PROJECT-123` (standard format)
- Works with any uppercase project key: `ABC-1`, `PROJ-999`, `TEAM-42`
- Detects tickets in:
  - Code comments (`// TODO: ABC-123`)
  - Markdown links (`[ABC-123](...)`)
  - Plain text (`See ABC-123 for details`)
  - Git commit messages
  - Multi-line text (searches current line first, then word under cursor)

## 🚀 Tips & Tricks

1. **Quick board access**: `<leader>jb` is your fastest way to check sprint progress
2. **Copy for Slack**: Use `<leader>jy` to copy ticket URLs for team chat
3. **Create from TODO**: When you write a TODO, press `<leader>jc` to create the ticket
4. **My tickets dashboard**: `<leader>jm` shows all your assigned work
5. **Visual mode**: Select ticket numbers from anywhere (even tables or lists)

## 🐛 Troubleshooting

### "No JIRA ticket found under cursor"

- Make sure cursor is on or near the ticket number
- Ticket must be in format: `PROJECT-123` (uppercase project key)
- Try selecting the text and using `<leader>jo` in visual mode

### Browser doesn't open

- On macOS: Should use `open` command
- On Linux: Requires `xdg-open`
- On Windows: Requires `start` command

### Wrong JIRA instance

```vim
" Check current URL
:JiraSetUrl

" Set correct URL (persists for session)
:JiraSetUrl https://correct-company.atlassian.net

" Or set permanently in ~/.zshrc:
export ATLASSIAN_INSTANCE_URL="https://correct-company.atlassian.net"
```

## 🔒 Privacy Note

This plugin only:

- Reads the `ATLASSIAN_INSTANCE_URL` environment variable
- Opens URLs in your default browser
- **Does NOT** make API calls or send data anywhere
- **Does NOT** require API tokens
- Works completely offline (except opening the browser)

## 📚 Related

- For AI-powered JIRA operations (create, search, comment), see [MCP_SETUP.md](MCP_SETUP.md)
- For JIRA command reference with AI assistants, see [JIRA_COMMANDS.md](JIRA_COMMANDS.md)
