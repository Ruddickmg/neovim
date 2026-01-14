return {
  {
    "neogit",
    keys = {
      { "<leader>gg", desc = "Show Neogit UI" },
    },
    after = function()
      local neogit = require("neogit")
      neogit.setup({
        integrations = {
          telescope = false,
          snacks = true,
          diffview = true,
        },
      })
      Snacks.keymap.set("n", "<leader>gg", neogit.open, { desc = "[G]it UI (Neogit)" })
    end,
  },
}
