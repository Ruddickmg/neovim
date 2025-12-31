return {
  {
    "nvim-ts-autotag",
    for_cat = "utility",
    after = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      })
    end,
  },
}
