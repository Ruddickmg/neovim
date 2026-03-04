return {
  {
    "auto-save.nvim",
    event = "FileType",
    after = function()
      require("auto-save").setup({
        execution_message = {
          enabled = false,
        },
        debounce_delay = 4000,
      })
      Snacks.keymap.set("n", "<leader>S", ":ASToggle<CR>", { desc = "Toggle Auto Save" })
    end,
  },
}
