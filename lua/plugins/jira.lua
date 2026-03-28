-- JIRA integration for Neovim
-- Quick access to JIRA tickets from within Neovim

return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>j", group = "jira" },
      },
    },
  },
}
