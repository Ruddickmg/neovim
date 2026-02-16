local keys = {
  {
    "<tab>",
    function()
      -- if there is a next edit, jump to it, otherwise apply it if any
      if not require("sidekick").nes_jump_or_apply() then
        return "<Tab>" -- fallback to normal tab
      end
    end,
    expr = true,
    desc = "Goto/Apply Next Edit Suggestion",
  },
  {
    "<leader>ac",
    function()
      require("sidekick.cli").select({ filter = { installed = true } })
    end,
    desc = "Select CLI",
  },
  {
    "<leader>ad",
    function()
      require("sidekick.cli").close()
    end,
    desc = "Detach a CLI Session",
  },
}

return {
  "sidekick.nvim",
  after = function()
    require("sidekick").setup({
      cli = {
        enabled = false, -- Disable CLI/Chat functionality
      },
      copilot = {
        enabled = true,
        -- Configuration for completion behavior
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<Tab>", -- or your preferred key
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
      },
    })
    for _, key in ipairs(keys) do
      Snacks.keymap.set(key.mode or {}, key[1], key[2], { expr = key.expr, desc = key.desc })
    end
  end,
}
