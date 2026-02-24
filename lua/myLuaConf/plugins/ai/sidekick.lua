return {
  "sidekick.nvim",
  event = { "InsertEnter" },
  after = function()
    require("sidekick").setup({
      cli = {
        enabled = false, -- Disable CLI/Chat functionality
      },
      copilot = {
        enabled = true,
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<Tab>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
      },
    })
    Snacks.keymap.set({ "n", "i" }, "<tab>", function()
      if not require("sidekick").nes_jump_or_apply() then
        return "<Tab>"
      end
    end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })
  end,
}
