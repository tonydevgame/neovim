# Neovim Configuration

Modern Neovim setup powered by [LazyVim](https://www.lazyvim.org/) with AI-enhanced features via GitHub Copilot.

## ✨ Features

- 🚀 **Lazy.nvim** plugin manager for fast startup
- 🤖 **AI-Powered Coding** with GitHub Copilot Chat & Avante
- 📦 **LSP Support** for multiple languages (TypeScript, Python, Java, Lua, HTML/CSS)
- 🎨 **Auto-formatting** with Conform.nvim
- 🔍 **Fuzzy Finding** with FzfLua
- 🌳 **Git Integration** with Lazygit
- 🧪 **Code Linting** with nvim-lint
- 🔧 **SonarLint** for code quality analysis

## 📋 Prerequisites

### macOS Installation

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Neovim (latest stable)
brew install neovim

# Install dependencies
brew install git node python ripgrep fd fzf

# Install GitHub CLI (for Copilot authentication)
brew install gh
```

### Authenticate GitHub Copilot

```bash
# Login to GitHub
gh auth login

# Authenticate Copilot
gh auth refresh -s copilot
```

## 🚀 Installation

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this config
git clone <your-repo-url> ~/.config/nvim

# Launch Neovim (plugins will auto-install)
nvim
```

First launch will:

1. Install lazy.nvim plugin manager
2. Download and install all plugins
3. Set up LSP servers via Mason
4. Build native dependencies (for Avante, etc.)

## ⌨️ Key Bindings

Leader key is `<Space>`

### 🗂️ File Navigation

| Key          | Action                 |
| ------------ | ---------------------- |
| `<leader>ff` | Find files             |
| `<leader>fs` | Search in files (grep) |
| `<leader>fb` | Find open buffers      |
| `<leader>e`  | Toggle file explorer   |

### 🪟 Window Management

| Key                   | Action                   |
| --------------------- | ------------------------ |
| `<leader>sv`          | Split vertical           |
| `<leader>sh`          | Split horizontal         |
| `<leader>se`          | Equal window sizes       |
| `<leader>sx`          | Close split              |
| `<leader>ll/lr/lk/lj` | Navigate between windows |

### 🤖 AI Features (Copilot)

**Inline Suggestions:**

- `<C-j>` (Insert mode) - Accept Copilot suggestion

**CopilotChat Commands (`<leader>a` prefix):**

| Key          | Action                     |
| ------------ | -------------------------- |
| `<leader>aa` | Open Copilot Chat          |
| `<leader>aq` | Quick chat (inline prompt) |
| `<leader>ae` | Explain code               |
| `<leader>at` | Generate tests             |
| `<leader>ar` | Review code                |
| `<leader>af` | Fix code                   |
| `<leader>ao` | Optimize code              |
| `<leader>ad` | Generate docs              |
| `<leader>aR` | Refactor code              |
| `<leader>ab` | Best practices review      |
| `<leader>as` | Security review            |
| `<leader>ap` | Performance analysis       |
| `<leader>aS` | Simplify code              |
| `<leader>aD` | Debug help                 |
| `<leader>al` | Add logging statements     |
| `<leader>aw` | Workspace context          |
| `<leader>am` | Generate commit message    |
| `<leader>ax` | Fix diagnostic errors      |
| `<leader>av` | Toggle chat window         |

### 📝 Code Editing

| Key                       | Action                |
| ------------------------- | --------------------- |
| `J` (Visual mode)         | Move selection down   |
| `K` (Visual mode)         | Move selection up     |
| `<leader>p` (Visual mode) | Paste without yanking |

### 🔍 Diagnostics & LSP

| Key         | Action                   |
| ----------- | ------------------------ |
| `<leader>d` | Show line diagnostics    |
| `<leader>D` | Show diagnostics list    |
| `gd`        | Go to definition         |
| `gr`        | Go to references         |
| `K`         | Show hover documentation |

### 🌳 Git Integration

| Key          | Action                       |
| ------------ | ---------------------------- |
| `<leader>lg` | Open Lazygit                 |
| `<leader>am` | Generate commit message (AI) |

## 🔧 Customization

### Change Leader Key

Edit `lua/config/options.lua`:

```lua
vim.g.mapleader = " "  -- Change this to your preferred key
```

### Add/Remove Plugins

Add plugin specs to files in `lua/plugins/`:

- `ai.lua` - AI & Copilot plugins
- `lsp.lua` - Language servers & formatters
- `explorer.lua` - File explorer
- `git.lua` - Git integrations
- `java.lua` - Java-specific setup

### LSP Languages

Managed via Mason. Edit `lua/plugins/lsp.lua` `ensure_installed` list:

```lua
ensure_installed = {
  "lua-language-server",
  "typescript-language-server",
  "pyright",
  -- Add more here
}
```

## 🐛 Troubleshooting

### Plugins not installing

```bash
# Remove lazy-lock and reinstall
rm ~/.config/nvim/lazy-lock.json
nvim --headless "+Lazy! sync" +qa
```

### Copilot not working

```bash
# Re-authenticate
gh auth refresh -s copilot

# Check status in Neovim
:Copilot status
```

### LSP not working

```bash
# Open Mason and install missing servers
:Mason
```

## 📚 Resources

- [LazyVim Documentation](https://www.lazyvim.org/)
- [Neovim Documentation](https://neovim.io/doc/)
- [GitHub Copilot](https://github.com/features/copilot)
- [Mason Registry](https://mason-registry.dev/registry/list)

## 📄 License

MIT
