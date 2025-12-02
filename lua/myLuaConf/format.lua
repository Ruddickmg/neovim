require('lze').load {
  {
    "stylua",
    for_cat = "format",
    dep_of = { "conform.nvim" },
    after = function ()
        print("doing stylua stuff")
    end
  },
  {
    "conform.nvim",
    for_cat = 'format',
    keys = {
      { "<leader>FF", desc = "[F]ormat [F]ile" },
    },
    after = function ()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          -- javascript = { { "prettierd", "prettier" } },
        },
        formatters = {
          stylua = {
            args = { "--search-parent-directories", "$FILENAME" },
          },
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>FF", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "[F]ormat [F]ile" })
    end,
  },
}
