return {
  "hermes.nvim",
  -- load = function ()
  --   -- in development, plugin is loaded from source
  -- end,
  after = function()
    vim.api.nvim_create_augroup("hermes", { clear = true })
    require("myLuaConf.plugins.ai.hermes.environment").detect()

    local hermes = require("hermes")
    local sessions = require("myLuaConf.plugins.ai.hermes.sessions")
    local registry = require("myLuaConf.plugins.ai.hermes.agents")
    local prompts = require("myLuaConf.plugins.ai.hermes.prompts")

    Snacks.keymap.set("n", "<leader>as", sessions.selectSession, { desc = "[S]essions" })
    Snacks.keymap.set("n", "<leader>ac", registry.selectAgent, { desc = "[C]onnect" })
    -- Snacks.keymap.set("n", "<leader>aX", hermes.cancel, { desc = "Cancel all session activity" })
    -- Snacks.keymap.set("n", "<leader>ax", hermes.cancel, { desc = "Cancel request" })
    Snacks.keymap.set("n", "<leader>aA", function()
      prompts.text.ask(sessions.sessionId)
    end, { desc = "[A]sk" })
    -- Snacks.keymap.set("n", "<leader>ah", prompts.history, { desc = "[H]istory" })
    -- Snacks.keymap.set({ "v" }, "<leader>aA", prompts.embedded.ask, { desc = "[A]sk" })

    hermes.setup({
      download = {
        auto = false,
      },
      agents = {
        ["my-custom-agent"] = {
          name = "Grant's Agent",
          command = "opencode",
          args = { "acp" },
          description = "Testing 123",
        },
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

    local state = require("myLuaConf.plugins.ai.hermes.state")
    local saved = state.load()
    local auto_connect = saved and saved.agent_id
    local auto_session_id = saved and saved.session_id

    if auto_connect then
      sessions.sessionId = auto_session_id
      registry.agentId = saved.agent_id
      hermes.connect(
        saved.agent_id,
        saved.distribution and { distribution = saved.distribution } or nil
      )
    end

    vim.api.nvim_create_autocmd("User", {
      group = "hermes",
      pattern = "ConnectionInitialized",
      callback = function(args)
        ---@type HermesConnectionInitialized
        local data = args.data
        local info = data.agentInfo
        vim.notify("Connected to " .. info.name .. " " .. info.version, vim.log.levels.INFO, { title = "Hermes" })
        state.current.agent_id = state.current.agent_id or registry.agentId
        state.save()
        if auto_session_id then
          hermes.load_session(auto_session_id)
        elseif not auto_connect then
          hermes.list_sessions()
        end
        auto_connect = false
        auto_session_id = nil
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = "hermes",
      pattern = "SessionLoaded",
      callback = function()
        if state.current.agent_id and sessions.sessionId then
          state.current.session_id = sessions.sessionId
          state.save()
        end
      end,
    })

    -- vim.api.nvim_create_autocmd("User", {
    --   group = "hermes",
    --   pattern = {
    --     "UserTextMessage",
    --     "UserResourceMessage"
    --   },
    --   callback = function(args)
    --     vim.notify("Recieved: " .. vim.inspect(args.data), vim.log.levels.INFO, { title = "Hermes - " .. args.match })
    --   end,
    -- })
  end,
}
