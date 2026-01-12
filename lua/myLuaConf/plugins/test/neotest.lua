local rust_enabled = nixCats("rust") or false

return {
  {
    "neotest-plenary",
    for_cat = "testing",
    dep_of = "neotest",
  },
  {
    "FixCursorHold.nvim",
    for_cat = "testing",
    dep_of = "neotest",
  },
  {
    "neotest",
    for_cat = "testing",
    after = function()
      local includedAdapters = {
        require("neotest-plenary"),
      }

      if rust_enabled then
        table.insert(includedAdapters, require("rustaceanvim.neotest"))
      end

      local neotest = require("neotest")

      neotest.setup({
        adapters = includedAdapters,
      })

      Snacks.keymap.set("n", "<leader>rt", neotest.run.run, { desc = "[T]est (nearest)" })
      Snacks.keymap.set("n", "<leader>ra", function()
        neotest.run.run(vim.fn.expand("%"))
      end, { desc = "[A]ll tests in current file" })
      Snacks.keymap.set("n", "<leader>rd", function()
        neotest.run.run({ strategy = "dap" })
      end, { desc = "[D]ebug tests" })
      Snacks.keymap.set("n", "<leader>xt", neotest.run.stop, { desc = "Stop tests" })
    end,
  },
}
