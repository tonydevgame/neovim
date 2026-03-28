-- Mason: install + manage LSPs, linters, formatters
return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSPs
        "lua-language-server",
        "typescript-language-server",
        "css-lsp",
        "html-lsp",
        "tailwindcss-language-server",
        "svelte-language-server",
        "prisma-language-server",
        "pyright",
        "emmet-ls",
        "jdtls",
        -- Formatters
        "prettier",
        "stylua",
        "shfmt",
        "black",
        "isort",
        -- Linters
        "eslint_d",
        "pylint",
        "sonarlint-language-server",
      },
    },
  },

  -- SonarLint
  {
    "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact", "python", "java", "html", "php", "xml" },
    config = function()
      require("sonarlint").setup({
        server = {
          cmd = {
            "sonarlint-language-server",
            "-stdio",
            "-analyzers",
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarphp.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarxml.jar"),
          },
        },
        filetypes = {
          "typescript",
          "javascript",
          "typescriptreact",
          "javascriptreact",
          "python",
          "java",
          "html",
          "php",
          "xml",
        },
      })
    end,
  },

  -- Formatting with conform
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua                = { "stylua" },
        python             = { "isort", "black" },
        javascript         = { "prettier" },
        javascriptreact    = { "prettier" },
        typescript         = { "prettier" },
        typescriptreact    = { "prettier" },
        svelte             = { "prettier" },
        vue                = { "prettier" },
        css                = { "prettier" },
        scss               = { "prettier" },
        html               = { "prettier" },
        json               = { "prettier" },
        jsonc              = { "prettier" },
        yaml               = { "prettier" },
        markdown           = { "prettier" },
        sh                 = { "shfmt" },
        bash               = { "shfmt" },
      },
    },
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript         = { "eslint_d" },
        javascriptreact    = { "eslint_d" },
        typescript         = { "eslint_d" },
        typescriptreact    = { "eslint_d" },
        svelte             = { "eslint_d" },
        vue                = { "eslint_d" },
        python             = { "pylint" },
      },
    },
  },

  -- Disable the eslint LSP server — it throws circular JSON errors with React
  -- flat configs. eslint_d via nvim-lint handles linting instead.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = { enabled = false },
      },
    },
    -- Free up <leader>cc for CopilotChat; move codelens to <leader>cL
    keys = {
      { "<leader>cc", false },
      { "<leader>cL", vim.lsp.codelens.run, desc = "Run Codelens" },
    },
  },
}
