return {
  {
    "copilot-lsp",
    dep_of = { "copilot", "sidekick" },
    event = { "InsertEnter" },
    after = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable("copilot")
      -- Snacks.keymap.set("n", "<tab>", function()
      --   local bufnr = vim.api.nvim_get_current_buf()
      --   local state = vim.b[bufnr].nes_state
      --   if state then
      --     -- Try to jump to the start of the suggestion edit.
      --     -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
      --     local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
      --       or (require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit())
      --     return nil
      --   else
      --     -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
      --     return "<C-i>"
      --   end
      -- end, { desc = "Accept Copilot NES suggestion", expr = true })
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
  {
    "copilot.lua",
    cmd = { "Copilot" },
    event = { "InsertEnter" },
    after = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
        },
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
  },
}
