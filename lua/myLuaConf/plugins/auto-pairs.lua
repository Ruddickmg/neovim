return {
  {
    "nvim-autopairs",
    for_cat = "utility",
    event = "InsertEnter",
    after = function()
      require("nvim-autopairs").setup({
        ts_check = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
        },
      })
    end,
  },
}
