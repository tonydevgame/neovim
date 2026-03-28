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
      -- Active provider - change this to switch
      provider = "copilot",
      
      -- All available providers - uncomment to activate
      providers = {
        -- GitHub Copilot (Active)
        copilot = {
          model = "gpt-4o",
        },
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
    opts = {
      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
      prompts = {
        Explain = {
          prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
        },
        Review = {
          prompt = "/COPILOT_REVIEW Review the selected code.",
        },
        Fix = {
          prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
        },
        Optimize = {
          prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability.",
        },
        Docs = {
          prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
        },
        Tests = {
          prompt = "/COPILOT_GENERATE Please generate tests for my code.",
        },
        FixDiagnostic = {
          prompt = "Please assist with the following diagnostic issue in file:",
        },
        Commit = {
          prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
        },
        -- Custom agent-like prompts
        Refactor = {
          prompt = "/COPILOT_GENERATE Refactor the selected code to improve its structure, maintainability, and follow best practices. Explain the changes made.",
        },
        BestPractices = {
          prompt = "Review the selected code and suggest improvements based on best practices, design patterns, and idiomatic usage for this language.",
        },
        Security = {
          prompt = "Analyze the selected code for security vulnerabilities and potential issues. Provide recommendations for fixing them.",
        },
        Performance = {
          prompt = "Analyze the selected code for performance issues. Suggest optimizations and explain the trade-offs.",
        },
        Simplify = {
          prompt = "/COPILOT_GENERATE Simplify the selected code while maintaining the same functionality. Make it more readable and maintainable.",
        },
        Debug = {
          prompt = "Help me debug this code. Identify potential issues and suggest fixes.",
        },
        LogStatements = {
          prompt = "/COPILOT_GENERATE Add appropriate logging statements to the selected code to help with debugging and monitoring.",
        },
        Workspace = {
          prompt = "Explain how the selected code fits into the larger codebase architecture. What is its role and how does it interact with other components?",
        },
      },
    },
    keys = {
      -- Open chat
      { "<leader>aa", "<cmd>CopilotChat<cr>", desc = "Copilot Chat", mode = { "n", "v" } },
      { "<leader>aq", function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input)
        end
      end, desc = "Quick chat", mode = { "n", "v" } },
      
      -- Code actions
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "Explain code", mode = { "n", "v" } },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "Generate tests", mode = { "n", "v" } },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "Review code", mode = { "n", "v" } },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "Fix code", mode = { "n", "v" } },
      { "<leader>ao", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize code", mode = { "n", "v" } },
      { "<leader>ad", "<cmd>CopilotChatDocs<cr>", desc = "Generate docs", mode = { "n", "v" } },
      
      -- Refactoring & best practices
      { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "Refactor code", mode = { "n", "v" } },
      { "<leader>ab", "<cmd>CopilotChatBestPractices<cr>", desc = "Best practices", mode = { "n", "v" } },
      { "<leader>as", "<cmd>CopilotChatSecurity<cr>", desc = "Security review", mode = { "n", "v" } },
      { "<leader>ap", "<cmd>CopilotChatPerformance<cr>", desc = "Performance review", mode = { "n", "v" } },
      { "<leader>aS", "<cmd>CopilotChatSimplify<cr>", desc = "Simplify code", mode = { "n", "v" } },
      
      -- Debugging & workspace
      { "<leader>aD", "<cmd>CopilotChatDebug<cr>", desc = "Debug help", mode = { "n", "v" } },
      { "<leader>al", "<cmd>CopilotChatLogStatements<cr>", desc = "Add logging", mode = { "n", "v" } },
      { "<leader>aw", "<cmd>CopilotChatWorkspace<cr>", desc = "Workspace context", mode = { "n", "v" } },
      
      -- Git integration
      { "<leader>am", "<cmd>CopilotChatCommit<cr>", desc = "Generate commit message", mode = { "n", "v" } },
      { "<leader>aM", "<cmd>CopilotChatCommitStaged<cr>", desc = "Commit staged message", mode = { "n", "v" } },
      
      -- Diagnostics & errors
      { "<leader>ax", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "Fix diagnostic", mode = { "n", "v" } },
      
      -- Toggle & reset
      { "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "Toggle chat", mode = { "n", "v" } },
      { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "Select model", mode = { "n", "v" } },
      { "<leader>aC", "<cmd>CopilotChatReset<cr>", desc = "Reset chat", mode = { "n", "v" } },
    },
  },
}
