return {
  {
    "auto-save.nvim",
    event = "FileType",
    after = function()
      require("auto-save").setup({
        debounce_delay = 1000,
      })
      Snacks.keymap("n", "<leader>S", ":ASToggle<CR>", { desc = "Toggle Auto Save" })
    end,
  },
}
