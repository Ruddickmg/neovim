return {
  {
    "substitute.nvim",
    for_cat = "utility",
    event = { "BufNewFile", "BufReadPre" },
    after = function()
      local substitute = require("substitute")
      local keymap = vim.keymap
      substitute.setup()
      keymap.set("n", "R", substitute.operator, { desc = "Substitute with motion", noremap = true })
      -- keymap.set("n", "R", substitute.line, { desc = "Substitute line", noremap = true })
      keymap.set("v", "R", substitute.visual, { desc = "Substitute in visutal mode", noremap = true })
    end,
  },
}
