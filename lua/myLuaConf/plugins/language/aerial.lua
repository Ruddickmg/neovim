return {
  {
    "aerial.nvim",
    event = "DeferredUIEnter",
    dep_of = { "lualine.nvim" },
    keys = {
      { "<leader>n", desc = "Aerial Symbol [N]avigator", mode = "n" },
      { "{", "<cmd>AerialPrev<CR>", desc = "Previus Symbol", mode = "n" },
      { "}", "<cmd>AerialNext<CR>", desc = "Next Symbol", mode = "n" },
    },
    after = function()
      local aerial = require("aerial")
      aerial.setup({ autojump = true })
      Snacks.keymap.set("n", "<leader>n", aerial.snacks_picker, { desc = "Aerial Symbol [N]avigator" })
    end,
  },
}
