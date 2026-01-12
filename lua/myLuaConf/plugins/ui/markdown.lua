return {
  {
    "render-markdown.nvim",
    for_cat = "markdown",
    ft = "markdown",
    after = function()
      require("render-markdown").setup({
        completions = { lsp = { enabled = true } },
      })
    end,
  },
}
