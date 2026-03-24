return {
  -- Disable LazyVim's built-in neo-tree in favour of nvim-tree
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local nvimtree = require("nvim-tree")

      -- recommended settings from nvim-tree documentation
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-web-devicons").setup({
        override = {
          lua = {
            icon = "👾",
            name = "Lua",
          },
          php = {
            icon = "👻",
            name = "Php",
          },
          vue = {
            icon = "ⓥ",
            name = "Vue",
          },
          css = {
            icon = "🐨",
            name = "Css",
          },
        },
      })

      nvimtree.setup({
        view = {
          width = 35,
          relativenumber = true,
        },
        renderer = {
          indent_markers = {
            enable = true,
          },
          icons = {
            glyphs = {
              default = "🦊",
              folder = {
                arrow_closed = "➜",
                arrow_open = "↓",
                default = "🏎",
              },
            },
          },
        },
        -- disable window_picker so explorer works well with window splits
        actions = {
          open_file = {
            window_picker = {
              enable = false,
            },
          },
        },
        filters = {
          custom = { ".DS_Store" },
        },
        git = {
          ignore = false,
        },
      })

      local keymap = vim.keymap
      keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>",          { desc = "Toggle file explorer" })
      keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>",  { desc = "Toggle file explorer on current file" })
      keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>",        { desc = "Collapse file explorer" })
      keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>",         { desc = "Refresh file explorer" })
    end,
  },
}
