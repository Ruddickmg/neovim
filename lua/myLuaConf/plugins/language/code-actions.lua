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
      Snacks.keymap.set({ "v", "n" }, "ca", actions_preview.code_actions)
    end,
  },
}
