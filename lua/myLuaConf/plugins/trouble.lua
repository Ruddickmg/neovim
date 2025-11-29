return {
  {
    "trouble.nvim",
    for_cat = "general",
    after = function()
      require("trouble").setup({
        -- your trouble.nvim configuration options
        -- e.g., use_diagnostic_signs = true,
        --       fold_open = "",
        --       fold_closed = "",
        --       indent_lines = "│",
        --       signs = {
        --         error = " ",
        --         warning = " ",
        --         info = " ",
        --         hint = " "
        --       },
        --       layout = "bottom",
        --       size = 10,
      })
    end
  }
}
