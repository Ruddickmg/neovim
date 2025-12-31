return {
  {
    "persistence.nvim",
    for_cat = "session-manager",
    dep_of = "snacks.nvim",
    after = function()
      local persistence = require("persistence")
      persistence.setup()

      vim.keymap.set("n", "<leader>qs", function()
        persistence.load()
      end, { desc = "Load session for current directory" })

      vim.keymap.set("n", "<leader>qS", function()
        persistence.select()
      end, { desc = "Select session to load" })

      vim.keymap.set("n", "<leader>ql", function()
        persistence.load({ last = true })
      end, { desc = "Load last session" })

      vim.keymap.set("n", "<leader>qd", function()
        persistence.stop()
      end, { desc = "Turn off persistence" })
    end,
  },
}
