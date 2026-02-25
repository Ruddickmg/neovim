return {
  {
    "nvim-eslint",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "tsx", "cjs", "mjs" },
    after = function()
      require("nvim-eslint").setup({})
    end,
  },
  {
    "typescript-tools.nvim",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "tsx", "cjs", "mjs" },
    after = function()
      require("typescript-tools").setup({
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          expose_as_code_action = "all",
          tsserver_max_memory = "auto",
        },
      })
    end,
  },
  {
    "ts_ls",
    dep_of = { "typescript-tools.nvim" },
    lsp = {},
  },
}
