return {
  {
    "trouble.nvim",
    for_cat = "general",
    after = function()
      require("trouble").setup({
        auto_open = false, -- auto open when there are items
        auto_preview = true, -- automatically open preview when on an item
        indent_guides = true, -- show indent guides
        warn_no_results = false, -- show a warning when there are no results
        open_no_results = true, -- open the trouble window when there are no results
      })
      vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "TroubleNormalNC", { bg = "none" })
    end,
  },
}
