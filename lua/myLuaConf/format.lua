return {
  {
    "conform.nvim",
    for_cat = "format",
    event = "BufWritePre",
    keys = {
      { "<leader>FF", desc = "[F]ormat [F]ile" },
    },
    after = function()
      local conform = require("conform")
      local formatting_options = {
        timeout_ms = 1000,
        lsp_format = false,
      }

      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          nix = { "nixfmt" },
          rust = { "rustfmt" },
        },
        format_on_save = formatting_options,
      })

      vim.keymap.set({ "n", "v" }, "<leader>FF", function()
        conform.format(formatting_options)
      end, { desc = "[F]ormat [F]ile" })
    end,
  },
}
