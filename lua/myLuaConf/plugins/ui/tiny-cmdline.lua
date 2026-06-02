return {
  {
    "tiny-cmdline.nvim",
    after = function()
      require("tiny-cmdline").setup({
        on_reposition = require("tiny-cmdline").adapters.blink,
        native_types = {},
        position = { y = "10%" },
      })
    end,
  },
}
