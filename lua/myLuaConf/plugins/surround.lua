return {
  {
    "nvim-surround",
    for_cat = "general.always",
    event = "DeferredUIEnter",
    after = function()
      require("nvim-surround").setup()
      vim.g.nvim_surround_no_normal_mappings = true
      Snacks.keymap.set("n", "s", "<Plug>(nvim-surround-normal)", { desc = "Add surrounding pair around motion" })
      Snacks.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)", { desc = "Delete surrounding pair around motion" })
      Snacks.keymap.set("n", "cs", "<Plug>(nvim-surround-change)", { desc = "Change surrounding pair around motion" })
    end,
  },
}
