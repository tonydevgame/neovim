-- All Copilot & AI plugins
return {
  -- Inline ghost text suggestions
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      -- Accept suggestion with <C-j> to avoid fighting completion menu
      vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Copilot accept suggestion",
      })
    end,
  },

  -- Avante
  {
    "yetone/avante.nvim",
    event   = "VeryLazy",
    version = false,
    build   = "make",
    opts = {
      provider = "copilot",
      providers = {
        copilot = { model = "gpt-4o" },
      },
      windows  = { position = "right", width = 30 },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-mini/mini.icons",
      "zbirenbaum/copilot.lua",
      { "HakonHarnes/img-clip.nvim", event = "VeryLazy", opts = {} },
      { "MeanderingProgrammer/render-markdown.nvim",
        ft   = { "markdown", "Avante" },
        opts = { file_types = { "markdown", "Avante" } },
      },
    },
  },

  -- CopilotChat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
    build = "make tiktoken",
    opts  = { show_help = true },
    keys = {
      { "<leader>cc", "<cmd>CopilotChat<cr>",        desc = "Copilot Chat" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Explain code" },
      { "<leader>ct", "<cmd>CopilotChatTests<cr>",   desc = "Generate tests" },
      { "<leader>cr", "<cmd>CopilotChatReview<cr>",  desc = "Review code" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>",     desc = "Fix code" },
    },
  },
}
