-- Java LSP via nvim-jdtls
-- LazyVim's lang.java extra handles the base setup;
-- this ensures jdtls is loaded and configured.
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
}
