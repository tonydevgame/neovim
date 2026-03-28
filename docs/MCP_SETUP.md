# MCP (Model Context Protocol) Setup

This guide covers setting up MCP servers for enhanced AI assistant capabilities with JIRA and other services.

> **Note:** For quick JIRA ticket access directly from Neovim (opening tickets in browser), see the built-in Lua integration in `lua/plugins/jira.lua`. Use `<leader>jo` to open tickets under cursor. This MCP setup is for advanced AI-powered JIRA operations (creating issues, searching, commenting, etc.) via Claude or VS Code Copilot.

## 🔧 Atlassian JIRA MCP Server

The Atlassian MCP server provides integration with JIRA, Confluence, and other Atlassian products.

### Prerequisites

```bash
# Install Node.js (if not already installed)
brew install node

# Verify installation
node --version
npm --version
```

### Installation

```bash
# Install the Atlassian MCP server globally
npm install -g @modelcontextprotocol/server-atlassian

# Or install locally in a project
npx @modelcontextprotocol/server-atlassian
```

### Configuration

#### For Claude Desktop

Edit `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-atlassian"],
      "env": {
        "ATLASSIAN_INSTANCE_URL": "https://your-domain.atlassian.net",
        "ATLASSIAN_EMAIL": "your-email@example.com",
        "ATLASSIAN_API_TOKEN": "your-api-token-here"
      }
    }
  }
}
```

#### For VS Code Copilot

Edit VS Code settings or create `.github/copilot/mcp.json` in your project:

```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-atlassian"],
      "env": {
        "ATLASSIAN_INSTANCE_URL": "https://your-domain.atlassian.net",
        "ATLASSIAN_EMAIL": "your-email@example.com",
        "ATLASSIAN_API_TOKEN": "your-api-token-here"
      }
    }
  }
}
```

### Getting Atlassian API Token

1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Click "Create API token"
3. Give it a meaningful name (e.g., "MCP Server")
4. Copy the token and store it securely
5. Add it to your config (see above)

### Environment Variables (Alternative)

Instead of hardcoding tokens in config files, use environment variables:

```bash
# Add to ~/.zshrc or ~/.bashrc
export ATLASSIAN_INSTANCE_URL="https://your-domain.atlassian.net"
export ATLASSIAN_EMAIL="your-email@example.com"
export ATLASSIAN_API_TOKEN="your-api-token-here"
```

Then simplify your MCP config:

```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-atlassian"]
    }
  }
}
```

### Available JIRA Commands via MCP

Once configured, you can ask your AI assistant to:

- **Create issues**: "Create a new bug in project ABC with title 'Login fails'"
- **Search issues**: "Find all open bugs assigned to me"
- **Update issues**: "Change issue ABC-123 status to In Progress"
- **Add comments**: "Add comment to ABC-123: Fixed in commit xyz"
- **Get issue details**: "Show me the details of ABC-123"
- **Transition issues**: "Move ABC-123 to Done"
- **Search with JQL**: "Find issues using JQL: project = ABC AND status = Open"

### Confluence Integration

The same MCP server also provides Confluence access:

- "Search Confluence for documentation on authentication"
- "Create a new page in space DEV"
- "Get the content of page 'API Guidelines'"

## 🔧 Other Useful MCP Servers

### GitHub MCP Server

```bash
# Install
npm install -g @modelcontextprotocol/server-github

# Configure with GitHub PAT
export GITHUB_TOKEN="your-github-token"
```

### GitLab MCP Server

```bash
npm install -g @modelcontextprotocol/server-gitlab
export GITLAB_TOKEN="your-gitlab-token"
export GITLAB_URL="https://gitlab.com"
```

### Filesystem MCP Server

```bash
npm install -g @modelcontextprotocol/server-filesystem
```

### Database MCP Server

```bash
npm install -g @modelcontextprotocol/server-postgres
# Or for other databases
npm install -g @modelcontextprotocol/server-sqlite
```

## 📁 Project-Specific MCP Config

For project-specific MCP servers, create `.github/copilot/mcp.json` in your project root:

```json
{
  "mcpServers": {
    "project-tools": {
      "command": "node",
      "args": ["./scripts/mcp-server.js"]
    }
  }
}
```

## 🧪 Testing MCP Connection

### For Claude Desktop

1. Restart Claude Desktop
2. Look for the hammer icon 🔨 in the chat
3. Click it to see available MCP tools
4. Try a command like "List my JIRA projects"

### For VS Code Copilot

1. Restart VS Code
2. Use Copilot Chat
3. Try commands like "@atlassian get issue ABC-123"

## 🐛 Troubleshooting

### MCP Server Not Found

```bash
# Check if installed
npm list -g | grep atlassian

# Reinstall if needed
npm install -g @modelcontextprotocol/server-atlassian --force
```

### Authentication Errors

```bash
# Verify your API token is valid
curl -u your-email@example.com:your-api-token \
  https://your-domain.atlassian.net/rest/api/3/myself
```

### Server Not Starting

```bash
# Test the server directly
npx @modelcontextprotocol/server-atlassian

# Check logs (location varies by platform)
# macOS: ~/Library/Logs/Claude/mcp*.log
```

## 🔐 Security Best Practices

1. **Never commit API tokens to git**
2. Use environment variables for sensitive data
3. Use `.env` files (and add to `.gitignore`)
4. Rotate tokens periodically
5. Use separate tokens for different purposes

## 📚 Resources

- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Atlassian MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/atlassian)
- [JIRA REST API](https://developer.atlassian.com/cloud/jira/platform/rest/v3/)
- [Claude Desktop MCP](https://docs.anthropic.com/claude/docs/mcp)

## 💾 Backup Your Config

```bash
# Backup Claude Desktop config
cp ~/Library/Application\ Support/Claude/claude_desktop_config.json \
   ~/Dropbox/backups/claude_desktop_config.json

# Or commit to this repo (without tokens!)
# Add a template version to this repo
```
