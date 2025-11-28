local rust_enabled = nixCats("rust") or false

return {
  {
    "neotest-plenary",
    for_cat = "testing",
    dep_of = "neotest"
  },
  {
    "FixCursorHold.nvim",
    for_cat = "testing",
    dep_of = "neotest"
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
    end
  }
}
