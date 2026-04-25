return {
  "hermes.nvim",
  -- load = function ()
  --   -- in development, plugin is loaded from source
  -- end,
  after = function()
    local hermes = require("hermes")
    local sessions = require("myLuaConf.plugins.ai.hermes.sessions")
    -- local prompts = require("myLuaConf.plugins.ai.hermes.prompts")

    Snacks.keymap.set("n", "<leader>as", sessions.selectSession, { desc = "[S]essions" })
    -- Snacks.keymap.set("n", "<leader>aA", prompts.text.ask, { desc = "[A]sk" })
    -- Snacks.keymap.set({ "v" }, "<leader>aA", prompts.embedded.ask, { desc = "[A]sk" })

    hermes.setup({
      log = {
        file = {
          level = "trace",
        },
      },
    })

    hermes.connect("opencode")

    vim.api.nvim_create_autocmd("User", {
      group = "hermes",
      pattern = "ConnectionInitialized",
      callback = function(args)
        local info = args.data.agentInfo
        vim.notify("Connected to " .. info.name .. " " .. info.version, vim.log.levels.INFO, { title = "Hermes" })
      end,
    })
  end,
}
