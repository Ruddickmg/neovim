return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = { "CopilotChatToggle", "CopilotChatOpen" },
    keys = {
      { "<leader>ac", desc = "Toggle [C]opilot Chat" },
      { "<leader>ac", desc = "Open [C]opilot Chat" },
    },
    after = function()
      require("CopilotChat").setup()
      Snacks.keymap.set("n", "<leader>ac", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle [C]opilot Chat" })
      Snacks.keymap.set("n", "<leader>aC", "<cmd>CopilotChatOpen<CR>", { desc = "Open [C]opilot Chat" })
    end,
  },
  {
    "copilot.lua",
    cmd = { "Copilot" },
    keys = {
      { "<leader>as", desc = "[S]et up Copilot" },
    },
    after = function()
      Snacks.keymap.set("n", "<leader>as", "<cmd>Copilot setup<CR>", { desc = "[S]et up Copilot" })
    end,
  },
}
