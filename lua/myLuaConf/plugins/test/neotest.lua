local javascript = require("myLuaConf.plugins.test.javascript")
local rust_enabled = nixCats("rust") or false

return {
  javascript.dependencies,
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
      local addAdapter = function(adapter)
        table.insert(includedAdapters, adapter)
      end

      if rust_enabled then
        addAdapter(require("rustaceanvim.neotest")({
          args = { "--no-capture" },
        }))
      end

      if javascript.enabled then
        for _, adapter in ipairs(javascript.adapters()) do
          addAdapter(adapter)
        end
      end

      local neotest = require("neotest")

      neotest.setup({
        adapters = includedAdapters,
      })

      Snacks.keymap.set("n", "<leader>tn", neotest.run.run, { desc = "[t]est" })
      Snacks.keymap.set("n", "<leader>ta", function()
        neotest.run.run(vim.fn.expand("%"))
      end, { desc = "[a]ll" })
      Snacks.keymap.set("n", "<leader>td", function()
        neotest.run.run({ strategy = "dap" })
      end, { desc = "[d]ebug" })
      Snacks.keymap.set("n", "<leader>ts", neotest.run.stop, { desc = "[s]top" })
      Snacks.keymap.set("n", "<leader>to", "<cmd>Neotest output<cr>", { desc = "[o]utput" })
      Snacks.keymap.set("n", "<leader>tv", "<cmd>Neotest summary<cr>", { desc = "[v]iew (summary)" })
    end,
  },
}
