#!/bin/bash
# Quick JIRA setup for Neovim

echo "🎫 Neovim JIRA Setup"
echo "===================="
echo ""
read -p "Enter your JIRA URL (e.g., https://yourcompany.atlassian.net): " JIRA_URL

if [ -z "$JIRA_URL" ]; then
    echo "❌ No URL provided. Exiting."
    exit 1
fi

# Add to .zshrc
echo "" >> ~/.zshrc
echo "# JIRA integration for Neovim" >> ~/.zshrc
echo "export ATLASSIAN_INSTANCE_URL=\"$JIRA_URL\"" >> ~/.zshrc

echo "✅ Added to ~/.zshrc"
echo ""
echo "Now run:"
echo "  source ~/.zshrc"
echo ""
echo "Then restart Neovim and try:"
echo "  1. Type a ticket like ABC-123"
echo "  2. Put cursor on it"
echo "  3. Press <leader>jo"
