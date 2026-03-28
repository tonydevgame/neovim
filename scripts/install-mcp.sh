#!/bin/bash

# MCP Server Installation Script
# Installs and configures Atlassian JIRA MCP server

set -e

echo "🚀 MCP Server Installation Script"
echo "=================================="

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Installing..."
    brew install node
else
    echo "✅ Node.js found: $(node --version)"
fi

# Check for npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found. Please install Node.js first."
    exit 1
else
    echo "✅ npm found: $(npm --version)"
fi

# Install Atlassian MCP server
echo ""
echo "📦 Installing Atlassian MCP Server..."
npm install -g @modelcontextprotocol/server-atlassian

echo ""
echo "✅ Atlassian MCP Server installed successfully!"

# Prompt for configuration
echo ""
echo "🔧 Configuration Setup"
echo "====================="

read -p "Enter your Atlassian instance URL (e.g., https://yourcompany.atlassian.net): " INSTANCE_URL
read -p "Enter your Atlassian email: " EMAIL
read -sp "Enter your Atlassian API token: " API_TOKEN
echo ""

# Add to shell profile
SHELL_CONFIG="$HOME/.zshrc"
if [ ! -f "$SHELL_CONFIG" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

echo ""
echo "📝 Adding environment variables to $SHELL_CONFIG..."

# Check if variables already exist
if grep -q "ATLASSIAN_INSTANCE_URL" "$SHELL_CONFIG"; then
    echo "⚠️  Atlassian variables already exist in $SHELL_CONFIG"
    read -p "Do you want to update them? (y/n): " UPDATE
    if [ "$UPDATE" = "y" ]; then
        # Remove old entries
        sed -i.bak '/ATLASSIAN_INSTANCE_URL/d' "$SHELL_CONFIG"
        sed -i.bak '/ATLASSIAN_EMAIL/d' "$SHELL_CONFIG"
        sed -i.bak '/ATLASSIAN_API_TOKEN/d' "$SHELL_CONFIG"
    else
        echo "⏭️  Skipping environment variable update"
        exit 0
    fi
fi

# Add new entries
cat >> "$SHELL_CONFIG" << EOF

# Atlassian MCP Server Configuration
export ATLASSIAN_INSTANCE_URL="$INSTANCE_URL"
export ATLASSIAN_EMAIL="$EMAIL"
export ATLASSIAN_API_TOKEN="$API_TOKEN"
EOF

echo "✅ Environment variables added to $SHELL_CONFIG"

# Test connection
echo ""
echo "🧪 Testing Atlassian connection..."
source "$SHELL_CONFIG"

TEST_RESULT=$(curl -s -u "$EMAIL:$API_TOKEN" "$INSTANCE_URL/rest/api/3/myself" | grep -o "accountId" || echo "failed")

if [ "$TEST_RESULT" = "accountId" ]; then
    echo "✅ Connection successful!"
else
    echo "⚠️  Connection test failed. Please verify your credentials."
fi

# Configure Claude Desktop (if exists)
CLAUDE_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
if [ -d "$(dirname "$CLAUDE_CONFIG")" ]; then
    echo ""
    read -p "Configure Claude Desktop? (y/n): " CONFIGURE_CLAUDE
    if [ "$CONFIGURE_CLAUDE" = "y" ]; then
        # Backup existing config
        if [ -f "$CLAUDE_CONFIG" ]; then
            cp "$CLAUDE_CONFIG" "$CLAUDE_CONFIG.backup"
            echo "📋 Backed up existing config to $CLAUDE_CONFIG.backup"
        fi
        
        # Create or update config
        cat > "$CLAUDE_CONFIG" << 'EOF'
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-atlassian"]
    }
  }
}
EOF
        echo "✅ Claude Desktop configured"
        echo "   Please restart Claude Desktop for changes to take effect"
    fi
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source $SHELL_CONFIG"
echo "2. If you configured Claude Desktop, restart the app"
echo "3. Test JIRA integration by asking: 'Show me my JIRA projects'"
echo ""
echo "📚 See docs/MCP_SETUP.md for more information"
