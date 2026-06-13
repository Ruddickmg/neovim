return {
  "hermes.nvim",
  -- load = function ()
  --   -- in development, plugin is loaded from source
  -- end,
  after = function()
    vim.api.nvim_create_augroup("hermes", { clear = true })
    local hermes = require("hermes")
    local sessions = require("myLuaConf.plugins.ai.hermes.sessions")
    local registry = require("myLuaConf.plugins.ai.hermes.agents")
    local prompts = require("myLuaConf.plugins.ai.hermes.prompts")

    Snacks.keymap.set("n", "<leader>as", sessions.selectSession, { desc = "[S]essions" })
    Snacks.keymap.set("n", "<leader>ac", registry.selectAgent, { desc = "[C]onnect" })
    Snacks.keymap.set("n", "<leader>aA", function()
      prompts.text.ask(sessions.sessionId)
    end, { desc = "[A]sk" })
    -- Snacks.keymap.set("n", "<leader>ah")
    -- Snacks.keymap.set({ "v" }, "<leader>aA", prompts.embedded.ask, { desc = "[A]sk" })

    hermes.setup({
      download = {
        auto = false,
      },
      log = {
        notification = {
          level = "info",
        },
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

    vim.api.nvim_create_autocmd("User", {
      group = "hermes",
      pattern = {
        "UserTextMessage",
        "UserResourceMessage"
      },
      callback = function(args)
        vim.notify("Recieved: " .. vim.inspect(args.data), vim.log.levels.INFO, { title = "Hermes - " .. args.match })
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = "hermes",
      pattern = {
        "AgentImageMessage",
        "AgentImageThought",
        "AgentResourceLinkMessage",
        "AgentResourceLinkThought",
        "AgentResourceMessage",
        "AgentResourceThought",
        "AgentTextThought",
        "AgentTextMessage",
      },
      callback = function(args)
        vim.notify("Recieved: " .. vim.inspect(args.data), vim.log.levels.INFO, { title = "Hermes - " .. args.match })
      end,
    })
  end,
}
