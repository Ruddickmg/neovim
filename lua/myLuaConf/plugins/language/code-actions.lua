return {
  {
    "actions-preview.nvim",
    event = { "LspAttach" },
    after = function()
      local actions_preview = require("actions-preview")
      actions_preview.setup({
        backend = { "snacks" },
        snacks = {
          layout = { preset = "default" },
        },
      })
      vim.keymap.set({ "v", "n" }, "gf", actions_preview.code_actions)
    end,
  },
}
