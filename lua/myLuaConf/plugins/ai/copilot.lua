return {
  {
    "blink-copilot",
    dep_of = {
      "copilot",
      "blink.cmp",
    },
    event = { "InsertEnter" },
  },
  {
    "copilot.lua",
    cmd = { "Copilot" },
    event = { "InsertEnter" },
    after = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        nes = {
          enabled = false,
        },
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
}
