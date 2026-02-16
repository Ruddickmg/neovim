return {
  "agentic.nvim",
  lazy = false,
  after = function()
    require("agentic").setup({
      provider = "opencode-acp",
      windows = {
        position = "right",
        width = "40%",
      },
      diff_preview = {
        enabled = true,
        layout = "split",
      },
    })
  end,
  keys = {
    {
      "<leader>ac",
      function()
        require("agentic").toggle()
      end,
      mode = { "n", "v", "i" },
      desc = "Toggle Agentic Chat",
    },
    {
      "<leader>af",
      function()
        require("agentic").add_file()
      end,
      mode = { "n", "v" },
      desc = "Add file or selection to Agentic Context",
    },
    {
      "<leader>av",
      function()
        require("agentic").add_selection()
      end,
    },
    {
      "<leader>as",
      function()
        require("agentic").new_session()
      end,
      mode = { "n", "v", "i" },
      desc = "New Agentic Session",
    },
    {
      "<leader>ar",
      function()
        require("agentic").restore_session()
      end,
      desc = "Agentic Restore Session",
      silent = true,
      mode = { "n", "v", "i" },
    },
  },
}
