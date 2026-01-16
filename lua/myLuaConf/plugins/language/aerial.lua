return {
  {
    "aerial.nvim",
    event = "DeferredUIEnter",
    dep_of = { "lualine.nvim" },
    keys = {
      { "<leader>a", desc = "[A]erial Symbol navigator", mode = "n" },
      { "{", "<cmd>AerialPrev<CR>", desc = "Previus Symbol", mode = "n" },
      { "}", "<cmd>AerialNext<CR>", desc = "Next Symbol", mode = "n" },
    },
    after = function()
      local aerial = require("aerial")
      aerial.setup({ autojump = true })
      Snacks.keymap.set("n", "<leader>a", aerial.snacks_picker, { desc = "[A]erial Symbol navigator" })
    end,
  },
}
