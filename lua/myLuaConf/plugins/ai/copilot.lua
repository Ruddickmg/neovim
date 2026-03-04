return {
  {
    "blink-copilot",
    dep_of = { "copilot-lsp", "copilot", "blink.cmp" },
    event = { "InsertEnter" },
  },
  {
    "copilot-lsp",
    dep_of = { "copilot" },
    event = { "InsertEnter" },
    after = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable("copilot")
    end,
  },
  {
    "copilot.lua",
    cmd = { "Copilot" },
    event = { "InsertEnter" },
    after = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = { "BlinkCmpMenuOpen", "InsertEnter" },
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = { "BlinkCmpMenuClose", "InsertLeave" },
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
  },
  {
    "CopilotChat.nvim",
    cmd = { "CopilotChatToggle", "CopilotChatOpen", "CopilotChatModels" },
    keys = {
      { "<leader>ac", desc = "Toggle [C]opilot Chat" },
      { "<leader>aC", desc = "Open [C]opilot Chat" },
      { "<leader>am", desc = "Select Copilot Chat [M]odel" },
      { "<leader>ap", desc = "Select Copilot Chat [P]rompts" },
    },
    after = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt_local.conceallevel = 0
        end,
      })
      require("CopilotChat").setup({
        model = "gpt-4.1", -- AI model to use
        temperature = 0.1, -- Lower = focused, higher = creative
        window = {
          layout = "float",
          width = 80, -- Fixed width in columns
          height = 20, -- Fixed height in rows
          border = "rounded", -- 'single', 'double', 'rounded', 'solid'
          title = "🤖 AI Assistant",
          zindex = 100, -- Ensure window stays on top
        },

        headers = {
          user = "👤 You",
          assistant = "🤖 Copilot",
          tool = "🔧 Tool",
        },

        separator = "━━",
        auto_fold = true,
        auto_insert_mode = true, -- Enter insert mode when opening
      })
      Snacks.keymap.set("n", "<leader>ac", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle [C]opilot Chat" })
      Snacks.keymap.set("n", "<leader>aC", "<cmd>CopilotChatOpen<CR>", { desc = "Open [C]opilot Chat" })
      Snacks.keymap.set("n", "<leader>am", "<cmd>CopilotChatModels<CR>", { desc = "Select Copilot Chat [M]odel" })
      Snacks.keymap.set("n", "<leader>ap", "<cmd>CopilotChatPrompts<CR>", { desc = "Select Copilot Chat [P]rompts" })
    end,
  },
}
